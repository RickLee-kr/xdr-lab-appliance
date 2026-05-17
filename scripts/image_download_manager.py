#!/usr/bin/env python3
"""Golden image download / verify / decompress (zstd) driven by images-manifest.json.

Invoked from xdr-lab-vm-manager.sh only. Emits JSONL events to vm-manager.log.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shlex
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterator


def utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def log_jsonl(log_path: Path | None, event: str, **fields: Any) -> None:
    rec: dict[str, Any] = {"ts": utc_now(), "event": event, **fields}
    line = json.dumps(rec, ensure_ascii=False) + "\n"
    if log_path and log_path.parent.is_dir():
        log_path.parent.mkdir(parents=True, exist_ok=True)
        with log_path.open("a", encoding="utf-8") as f:
            f.write(line)
    # Mirror to stderr for operator visibility (engine also uses vm-manager.log).
    print(line, end="", file=sys.stderr)


def load_manifest(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, dict):
        raise ValueError("manifest root must be an object")
    imgs = data.get("images")
    if not isinstance(imgs, list):
        raise ValueError("manifest.images must be a list")
    return data


def load_state(path: Path) -> dict[str, Any]:
    if not path.is_file():
        return {"schema_version": 1, "images": {}}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            return {"schema_version": 1, "images": {}}
        if "images" not in data or not isinstance(data["images"], dict):
            data["images"] = {}
        return data
    except (json.JSONDecodeError, OSError):
        return {"schema_version": 1, "images": {}}


def is_placeholder_url(url: str) -> bool:
    lowered = url.lower()
    return (
        not url
        or "replace_me.example.invalid" in lowered
        or "replace_me" in lowered
        or "placeholder" in lowered
    )


def is_stellar_sensor_image(image: dict[str, Any]) -> bool:
    url = str(image.get("url", "")).lower()
    name = str(image.get("name", "")).lower()
    return (
        image.get("vm_role") == "sensor-vm"
        or "stellarcyber.ai" in url
        or "modular_ds" in name
        or "modular-ds" in name
    )


def load_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.is_file():
        return values
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        if key not in ("STELLAR_DOWNLOAD_USER", "STELLAR_DOWNLOAD_PASSWORD"):
            continue
        try:
            parsed = shlex.split(value, posix=True)
            values[key] = parsed[0] if parsed else ""
        except ValueError:
            values[key] = value.strip().strip("'\"")
    return values


def stellar_credentials(env_file: Path, *, log_path: Path | None) -> tuple[str, str]:
    file_values = load_env_file(env_file)
    user = os.environ.get("STELLAR_DOWNLOAD_USER") or file_values.get("STELLAR_DOWNLOAD_USER", "")
    password = os.environ.get("STELLAR_DOWNLOAD_PASSWORD") or file_values.get(
        "STELLAR_DOWNLOAD_PASSWORD", ""
    )
    if env_file.is_file():
        try:
            if env_file.stat().st_mode & 0o077:
                log_jsonl(
                    log_path,
                    "stellar_download_env_permissions_warning",
                    path=str(env_file),
                    recommendation="chmod 600",
                )
        except OSError:
            pass
    if not user or not password:
        raise RuntimeError(
            "Stellar download credentials missing. Set STELLAR_DOWNLOAD_USER and "
            "STELLAR_DOWNLOAD_PASSWORD in the environment or in "
            f"{env_file} (chmod 600 recommended)."
        )
    return user, password


def save_state(path: Path, state: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    state["updated_utc"] = utc_now()
    path.write_text(json.dumps(state, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def under_xdr_root(xdr_root: Path, rel_or_abs: str) -> Path:
    p = Path(rel_or_abs)
    if p.is_absolute():
        rp = p.resolve()
    else:
        rp = (xdr_root / p).resolve()
    root = xdr_root.resolve()
    try:
        rp.relative_to(root)
    except ValueError as e:
        raise ValueError(f"output_path escapes XDR_ROOT: {rel_or_abs}") from e
    return rp


def iter_selected(
    images: list[dict[str, Any]],
    select: str,
) -> Iterator[dict[str, Any]]:
    roles = {"sensor-vm", "victim-linux", "windows-victim"}
    if select in ("MANIFEST_ALL", "__manifest_all__", ""):
        for im in images:
            yield im
        return
    if select == "all":
        # Reserved: caller should not use for manifest iteration; treat as all entries.
        for im in images:
            yield im
        return
    if select in roles:
        for im in images:
            if im.get("vm_role") == select:
                yield im
        return
    for im in images:
        if im.get("name") == select:
            yield im
            return


def has_entries_for_role(manifest: Path, role: str) -> bool:
    data = load_manifest(manifest)
    for im in data.get("images", []):
        if isinstance(im, dict) and im.get("vm_role") == role:
            return True
    return False


def which_or_none(name: str) -> str | None:
    p = shutil.which(name)
    return p


def download_url(
    url: str,
    dest: Path,
    *,
    log_path: Path | None,
    dry_run: bool,
    credentials: tuple[str, str] | None = None,
) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    partial = dest.parent / (dest.name + ".part")
    aria = which_or_none("aria2c")
    curl = which_or_none("curl")
    if dry_run:
        tool = "aria2c" if aria else "curl" if curl else "(none)"
        log_jsonl(
            log_path,
            "image_download_started",
            url=url,
            dest=str(dest),
            tool=tool,
            dry_run=True,
        )
        return
    user = password = ""
    if credentials:
        user, password = credentials
    if aria:
        log_jsonl(log_path, "image_download_started", url=url, dest=str(dest), tool="aria2c")
        cmd = [
            aria,
            "-x",
            "16",
            "-s",
            "16",
            "-c",
            "-d",
            str(partial.parent),
            "-o",
            partial.name,
        ]
        if credentials:
            cmd.extend(["--http-user", user, "--http-passwd", password])
        cmd.append(url)
        r = subprocess.run(cmd, check=False)
        if r.returncode != 0:
            log_jsonl(
                log_path,
                "image_download_failed",
                url=url,
                dest=str(dest),
                tool="aria2c",
                rc=r.returncode,
            )
            raise RuntimeError(f"aria2c failed (rc={r.returncode}) for {url}")
        shutil.move(str(partial), str(dest))
        log_jsonl(log_path, "image_download_success", url=url, dest=str(dest), tool="aria2c")
        return
    if curl:
        log_jsonl(log_path, "image_download_started", url=url, dest=str(dest), tool="curl")
        cmd = ["curl", "-fL", "-C", "-", "--retry", "3", "--retry-delay", "2"]
        if credentials:
            cmd.extend(["--user", f"{user}:{password}"])
        cmd.extend(["-o", str(dest), url])
        r = subprocess.run(cmd, check=False)
        if r.returncode != 0:
            log_jsonl(
                log_path,
                "image_download_failed",
                url=url,
                dest=str(dest),
                tool="curl",
                rc=r.returncode,
            )
            raise RuntimeError(f"curl failed (rc={r.returncode}) for {url}")
        log_jsonl(log_path, "image_download_success", url=url, dest=str(dest), tool="curl")
        return
    raise RuntimeError("Neither aria2c nor curl found in PATH (required for image downloads)")


def verify_checksum(
    path: Path,
    expected: str,
    *,
    log_path: Path | None,
    dry_run: bool,
    image_name: str,
) -> bool:
    if dry_run:
        log_jsonl(
            log_path,
            "image_checksum_verified",
            image=image_name,
            path=str(path),
            dry_run=True,
        )
        return True
    got = sha256_file(path)
    if got.lower() != expected.lower():
        log_jsonl(
            log_path,
            "image_checksum_failed",
            image=image_name,
            path=str(path),
            expected=expected,
            actual=got,
        )
        return False
    log_jsonl(log_path, "image_checksum_verified", image=image_name, path=str(path))
    return True


def run_zstd_decompress(zst: Path, out: Path, *, log_path: Path | None, dry_run: bool, image_name: str) -> None:
    zstd = which_or_none("zstd")
    if not zstd:
        raise RuntimeError(
            "zstd command not found in PATH; install zstd (e.g. apt install zstd) "
            "to decompress .zst artifacts from images-manifest.json"
        )
    if dry_run:
        log_jsonl(
            log_path,
            "image_decompress_started",
            image=image_name,
            src=str(zst),
            dst=str(out),
            dry_run=True,
        )
        log_jsonl(
            log_path,
            "image_decompress_success",
            image=image_name,
            dst=str(out),
            dry_run=True,
        )
        return
    out.parent.mkdir(parents=True, exist_ok=True)
    log_jsonl(log_path, "image_decompress_started", image=image_name, src=str(zst), dst=str(out))
    r = subprocess.run(
        [zstd, "-d", "-f", str(zst), "-o", str(out)],
        check=False,
    )
    if r.returncode != 0:
        log_jsonl(
            log_path,
            "image_download_failed",
            image=image_name,
            phase="decompress",
            rc=r.returncode,
        )
        raise RuntimeError(f"zstd decompress failed (rc={r.returncode}) for {zst}")
    log_jsonl(log_path, "image_decompress_success", image=image_name, dst=str(out))


def infer_artifact_type(image: dict[str, Any], path: Path) -> str:
    explicit = str(image.get("artifact_type", "") or image.get("type", "")).strip().lower()
    if explicit:
        return explicit
    if bool(image.get("chmod_executable")) or path.name.endswith(".sh"):
        return "shell-script"
    if path.name.endswith(".qcow2"):
        return "qcow2"
    return ""


def verify_artifact_type(
    path: Path,
    artifact_type: str,
    *,
    log_path: Path | None,
    dry_run: bool,
    image_name: str,
) -> bool:
    if not artifact_type:
        return True
    if dry_run:
        log_jsonl(
            log_path,
            "image_artifact_type_verified",
            image=image_name,
            path=str(path),
            artifact_type=artifact_type,
            dry_run=True,
        )
        return True
    if artifact_type in ("shell-script", "shell", "script"):
        if not path.is_file():
            print(f"ERROR: {image_name}: shell script missing: {path}", file=sys.stderr)
            return False
        try:
            first = path.read_bytes()[:256]
        except OSError as exc:
            print(f"ERROR: {image_name}: unable to read shell script {path}: {exc}", file=sys.stderr)
            return False
        if not os.access(path, os.X_OK):
            print(f"ERROR: {image_name}: shell script is not executable: {path}", file=sys.stderr)
            return False
        first_line = first.splitlines()[0].lower() if first.splitlines() else b""
        if not first.startswith(b"#!") or b"sh" not in first_line:
            print(f"ERROR: {image_name}: artifact is not an executable shell script: {path}", file=sys.stderr)
            return False
    elif artifact_type == "qcow2":
        if not path.is_file():
            print(f"ERROR: {image_name}: qcow2 image missing: {path}", file=sys.stderr)
            return False
        try:
            magic = path.read_bytes()[:4]
        except OSError as exc:
            print(f"ERROR: {image_name}: unable to read qcow2 image {path}: {exc}", file=sys.stderr)
            return False
        if magic != b"QFI\xfb":
            print(f"ERROR: {image_name}: artifact is not a QEMU QCOW2 image: {path}", file=sys.stderr)
            return False
    else:
        raise RuntimeError(f"unsupported artifact_type for {image_name}: {artifact_type}")
    log_jsonl(
        log_path,
        "image_artifact_type_verified",
        image=image_name,
        path=str(path),
        artifact_type=artifact_type,
    )
    return True


def cmd_download(args: argparse.Namespace) -> int:
    manifest = Path(args.manifest)
    state_path = Path(args.state)
    xdr_root = Path(args.xdr_root).resolve()
    log_path = Path(args.log_file) if args.log_file else None
    dry_run = bool(args.dry_run)
    force = bool(args.force) or os.environ.get("XDR_LAB_IMAGE_DOWNLOAD_FORCE") == "1"
    stellar_env = Path(os.environ.get("XDR_LAB_STELLAR_DOWNLOAD_ENV") or args.stellar_env)

    data = load_manifest(manifest)
    images: list[dict[str, Any]] = [i for i in data["images"] if isinstance(i, dict)]
    state = load_state(state_path)
    st_images: dict[str, Any] = state.setdefault("images", {})

    select = args.select or "MANIFEST_ALL"
    selected = list(iter_selected(images, select))
    if args.version:
        selected = [im for im in selected if str(im.get("version", "")) == str(args.version)]
    if not selected:
        msg = f"no manifest images matched select={select!r}"
        if dry_run:
            print(f"DRY-RUN: {msg}", file=sys.stdout)
            return 0
        print(f"ERROR: {msg}", file=sys.stderr)
        return 2

    placeholder_images = [
        str(im.get("name", "") or "?")
        for im in selected
        if is_placeholder_url(str(im.get("url", "")))
    ]
    if placeholder_images:
        msg = (
            "CONFIG_PLACEHOLDER_ERROR: refusing to download placeholder artifact URLs "
            f"for select={select!r}: {', '.join(placeholder_images)}. "
            "Replace config/images-manifest.json URLs with real artifacts or install them manually."
        )
        log_jsonl(log_path, "image_download_failed", reason=msg)
        print(f"ERROR: {msg}", file=sys.stderr)
        return 2

    sensor_selected = [im for im in selected if is_stellar_sensor_image(im)]
    sensor_credentials: tuple[str, str] | None = None
    if sensor_selected and not dry_run:
        try:
            sensor_credentials = stellar_credentials(stellar_env, log_path=log_path)
        except RuntimeError as exc:
            log_jsonl(log_path, "image_download_failed", reason="stellar_credentials_missing")
            print(f"ERROR: {exc}", file=sys.stderr)
            return 2

    if dry_run:
        print("DRY-RUN image download plan:", file=sys.stdout)
        for im in selected:
            outp = under_xdr_root(xdr_root, str(im["output_path"]))
            print(
                f"  - {im.get('name')} vm_role={im.get('vm_role')} version={im.get('version')} "
                f"url={im.get('url')} -> {outp} compressed={im.get('compressed')} required={im.get('required', True)}",
                file=sys.stdout,
            )
        return 0

    overall_rc = 0

    for im in selected:
        name = str(im.get("name", ""))
        required = bool(im.get("required", True))
        version = str(im.get("version", ""))
        url = str(im.get("url", ""))
        sha = str(im.get("sha256", "")).strip()
        size_b = im.get("size_bytes")
        compressed = bool(im.get("compressed", False))
        ctype = (im.get("compression") or im.get("compression_type") or "").strip()
        keep_zst = bool(im.get("keep_compressed_artifact", im.get("keep_zst", True)))

        if not name or not url:
            msg = f"manifest entry incomplete: name={name!r} url set={bool(url)}"
            if required:
                log_jsonl(log_path, "image_download_failed", image=name or "?", reason=msg)
                print(f"ERROR: {msg}", file=sys.stderr)
                return 2
            log_jsonl(log_path, "image_download_failed", image=name or "?", reason=msg, skipped_optional=True)
            continue

        try:
            out_path = under_xdr_root(xdr_root, str(im["output_path"]))
        except Exception as e:
            if required:
                log_jsonl(log_path, "image_download_failed", image=name, reason=str(e))
                print(f"ERROR: {e}", file=sys.stderr)
                return 2
            log_jsonl(log_path, "image_download_failed", image=name, reason=str(e), skipped_optional=True)
            continue

        prev = st_images.get(name, {}) if isinstance(st_images.get(name), dict) else {}
        last_checked = utc_now()

        def write_state(**kwargs: Any) -> None:
            entry = {
                "downloaded": kwargs.get("downloaded", prev.get("downloaded", False)),
                "verified": kwargs.get("verified", prev.get("verified", False)),
                "version": version,
                "path": str(out_path),
                "size_bytes": kwargs.get("size_bytes"),
                "sha256": sha,
                "last_checked_time": last_checked,
                "vm_role": im.get("vm_role"),
            }
            st_images[name] = entry
            save_state(state_path, state)

        if compressed:
            if ctype and ctype.lower() not in ("", "zst"):
                msg = f"unsupported compression type: {ctype!r} (only zst)"
                if required:
                    print(f"ERROR: {msg}", file=sys.stderr)
                    return 2
                log_jsonl(log_path, "image_download_failed", image=name, reason=msg, skipped_optional=True)
                continue
            dl_path = out_path.with_suffix(out_path.suffix + ".zst")
        else:
            dl_path = out_path

        # Cache hit: manifest sha256 always refers to the on-wire artifact (.zst or final file).
        if not force:
            meta_ok = (
                prev.get("version") == version
                and prev.get("verified") is True
                and (not sha or str(prev.get("sha256", "")).lower() == sha.lower())
            )
            if meta_ok and out_path.is_file():
                if compressed:
                    if keep_zst and dl_path.is_file():
                        if not sha or verify_checksum(dl_path, sha, log_path=log_path, dry_run=False, image_name=name):
                            log_jsonl(
                                log_path,
                                "image_cache_hit",
                                image=name,
                                path=str(out_path),
                                version=version,
                            )
                            write_state(
                                downloaded=True,
                                verified=True,
                                size_bytes=out_path.stat().st_size,
                            )
                            continue
                    elif not keep_zst or not dl_path.is_file():
                        log_jsonl(
                            log_path,
                            "image_cache_hit",
                            image=name,
                            path=str(out_path),
                            version=version,
                        )
                        write_state(
                            downloaded=True,
                            verified=True,
                            size_bytes=out_path.stat().st_size,
                        )
                        continue
                else:
                    if not sha or verify_checksum(out_path, sha, log_path=log_path, dry_run=False, image_name=name):
                        log_jsonl(
                            log_path,
                            "image_cache_hit",
                            image=name,
                            path=str(out_path),
                            version=version,
                        )
                        write_state(
                            downloaded=True,
                            verified=True,
                            size_bytes=out_path.stat().st_size,
                        )
                        continue

        try:
            need_dl = force or not dl_path.is_file()
            if not need_dl and compressed:
                if sha and not verify_checksum(dl_path, sha, log_path=log_path, dry_run=False, image_name=name):
                    if required:
                        try:
                            dl_path.unlink()
                        except OSError:
                            pass
                        need_dl = True
                    else:
                        log_jsonl(log_path, "image_download_failed", image=name, reason="checksum", skipped_optional=True)
                        continue
            if not need_dl and not compressed:
                if sha and not verify_checksum(out_path, sha, log_path=log_path, dry_run=False, image_name=name):
                    if required:
                        try:
                            out_path.unlink()
                        except OSError:
                            pass
                        need_dl = True
                    else:
                        log_jsonl(log_path, "image_download_failed", image=name, reason="checksum", skipped_optional=True)
                        continue

            if need_dl:
                download_url(
                    url,
                    dl_path,
                    log_path=log_path,
                    dry_run=dry_run,
                    credentials=sensor_credentials if is_stellar_sensor_image(im) else None,
                )
                if isinstance(size_b, int) and size_b > 0 and dl_path.is_file():
                    act = dl_path.stat().st_size
                    if act != size_b:
                        log_jsonl(
                            log_path,
                            "image_download_failed",
                            image=name,
                            reason="size_mismatch",
                            expected_bytes=size_b,
                            actual_bytes=act,
                        )
                        if required:
                            try:
                                dl_path.unlink()
                            except OSError:
                                pass
                            return 2

            if sha and not verify_checksum(dl_path, sha, log_path=log_path, dry_run=dry_run, image_name=name):
                if required:
                    return 2
                log_jsonl(log_path, "image_download_failed", image=name, reason="checksum", skipped_optional=True)
                continue

            if compressed:
                need_decomp = force or not out_path.is_file()
                if need_decomp:
                    if out_path.exists():
                        out_path.unlink()
                    run_zstd_decompress(dl_path, out_path, log_path=log_path, dry_run=dry_run, image_name=name)
                if not keep_zst and not dry_run:
                    try:
                        dl_path.unlink()
                    except OSError:
                        pass
            if im.get("chmod_executable") or str(out_path).endswith(".sh"):
                try:
                    mode = out_path.stat().st_mode
                    out_path.chmod(mode | 0o111)
                except OSError:
                    pass
            artifact_type = infer_artifact_type(im, out_path)
            if not verify_artifact_type(
                out_path,
                artifact_type,
                log_path=log_path,
                dry_run=dry_run,
                image_name=name,
            ):
                if required:
                    return 2
                log_jsonl(log_path, "image_download_failed", image=name, reason="artifact_type", skipped_optional=True)
                continue
            write_state(
                downloaded=True,
                verified=True,
                size_bytes=out_path.stat().st_size if out_path.is_file() else None,
            )
        except Exception as e:
            if required:
                log_jsonl(log_path, "image_download_failed", image=name, reason=str(e))
                print(f"ERROR: {name}: {e}", file=sys.stderr)
                return 2
            log_jsonl(log_path, "image_download_failed", image=name, reason=str(e), skipped_optional=True)
            overall_rc = overall_rc or 0

    return overall_rc


def cmd_status(args: argparse.Namespace) -> int:
    manifest = Path(args.manifest)
    state_path = Path(args.state)
    xdr_root = Path(args.xdr_root).resolve()
    state = load_state(state_path)
    print(f"state_file: {state_path}", file=sys.stdout)
    print(f"manifest: {manifest} exists={manifest.is_file()}", file=sys.stdout)
    if not manifest.is_file():
        return 0
    data = load_manifest(manifest)
    for im in data.get("images", []):
        if not isinstance(im, dict):
            continue
        name = str(im.get("name", ""))
        try:
            outp = under_xdr_root(xdr_root, str(im.get("output_path", "")))
        except Exception as e:
            print(f"  {name} (bad output_path: {e})", file=sys.stdout)
            continue
        st = state.get("images", {}).get(name, {})
        disk = outp.is_file()
        sz = outp.stat().st_size if disk else "-"
        print(
            f"  {name} role={im.get('vm_role')} version={im.get('version')} "
            f"disk={disk} size={sz} state_verified={st.get('verified')} path={outp}",
            file=sys.stdout,
        )
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description="XDR Lab image download manager")
    ap.add_argument("--manifest", required=True)
    ap.add_argument("--state", required=True)
    ap.add_argument("--xdr-root", required=True)
    ap.add_argument("--log-file", default="")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--stellar-env", default="/etc/xdr-lab/stellar-download.env")
    sub = ap.add_subparsers(dest="cmd", required=True)

    sp = sub.add_parser("download", help="Download / verify / decompress per manifest")
    sp.add_argument("--select", default="", help="MANIFEST_ALL | vm_role | image name")
    sp.add_argument("--version", default="", help="Optional artifact version filter")
    sp.add_argument("--force", action="store_true")
    sp.set_defaults(func=cmd_download)

    sp2 = sub.add_parser("status", help="Print manifest vs disk vs state")
    sp2.set_defaults(func=cmd_status)

    sp3 = sub.add_parser("has-role", help="Exit 0 if manifest defines vm_role")
    sp3.add_argument("--role", required=True)
    sp3.set_defaults(func="has_role")

    args = ap.parse_args()
    if getattr(args, "func", None) == "has_role":
        mp = Path(args.manifest)
        if not mp.is_file():
            return 1
        role = args.role
        ok = has_entries_for_role(mp, role)
        print("yes" if ok else "no", file=sys.stdout)
        return 0 if ok else 1

    # log file optional for status
    if not args.log_file:
        args.log_file = None
    else:
        args.log_file = str(args.log_file)
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main())
