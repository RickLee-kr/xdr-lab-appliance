#!/usr/bin/env python3
"""Runtime-managed tool inventory for XDR Lab.

Tools live under runtime/tools and state lives under runtime/state/tools.json.
Golden Images must not bake these mutable repositories into the image layer.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Mapping


ATOMIC_REPO_URL = "https://github.com/redcanaryco/atomic-red-team.git"


def dry_run() -> bool:
    return os.environ.get("XDR_LAB_DRY_RUN") == "1"


def utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def load_json(path: Path, default: Any) -> Any:
    if not path.is_file():
        return default
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return default


def save_json_atomic(path: Path, data: Mapping[str, Any]) -> None:
    if dry_run():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(dict(data), indent=2, sort_keys=True) + "\n"
    fd, tmp = tempfile.mkstemp(prefix=".tmp-", dir=str(path.parent), text=True)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            fh.write(text)
        os.replace(tmp, path)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


def run(argv: list[str], *, cwd: Path | None = None, timeout: int = 900) -> tuple[int, str]:
    try:
        proc = subprocess.run(argv, cwd=str(cwd) if cwd else None, text=True, capture_output=True, timeout=timeout, check=False)
        return int(proc.returncode), ((proc.stdout or "") + (proc.stderr or ""))[-4000:]
    except FileNotFoundError as exc:
        return 127, str(exc)
    except subprocess.TimeoutExpired:
        return 124, f"timeout after {timeout}s"


class ToolRuntime:
    def __init__(self, xdr_root: Path) -> None:
        self.xdr_root = xdr_root
        self.runtime = xdr_root / "runtime"
        self.tools_dir = self.runtime / "tools"
        self.state_path = self.runtime / "state" / "tools.json"
        self.config_path = xdr_root / "config" / "tool-runtime.json"
        self.config = load_json(self.config_path, {})

    @property
    def atomic_path(self) -> Path:
        cfg = self.config.get("atomic") if isinstance(self.config.get("atomic"), dict) else {}
        raw = str(cfg.get("install_path") or self.tools_dir / "atomic-red-team")
        return Path(raw)

    def load_state(self) -> dict[str, Any]:
        state = load_json(self.state_path, {})
        return state if isinstance(state, dict) else {}

    def write_state(self, state: dict[str, Any]) -> None:
        state["updated_utc"] = utc_now()
        save_json_atomic(self.state_path, state)

    def atomic_version(self) -> str:
        path = self.atomic_path
        if not (path / ".git").is_dir():
            return ""
        rc, out = run(["git", "rev-parse", "--short", "HEAD"], cwd=path, timeout=20)
        return out.strip().splitlines()[-1] if rc == 0 and out.strip() else ""

    def write_atomic_state(self, *, installed: bool, status: str, detail: str = "") -> dict[str, Any]:
        state = self.load_state()
        block = {
            "managed": True,
            "installed": installed,
            "status": status,
            "version": self.atomic_version(),
            "path": str(self.atomic_path),
            "last_checked_utc": utc_now(),
            "detail": detail,
        }
        state["atomic"] = block
        state["atomic_red_team"] = {
            "installed": installed,
            "version": block["version"],
            "path": str(self.atomic_path),
        }
        state.setdefault("caldera", self.caldera_state())
        self.write_state(state)
        return block

    def caldera_state(self) -> dict[str, Any]:
        caldera_home = Path(str(os.environ.get("CALDERA_HOME") or "/opt/caldera"))
        version = ""
        if (caldera_home / ".git").is_dir():
            rc, out = run(["git", "rev-parse", "--short", "HEAD"], cwd=caldera_home, timeout=20)
            if rc == 0:
                version = out.strip().splitlines()[-1]
        return {
            "managed": True,
            "installed": (caldera_home / "server.py").is_file(),
            "version": version,
            "path": str(caldera_home),
            "last_checked_utc": utc_now(),
        }

    def verify_atomic(self) -> dict[str, Any]:
        path = self.atomic_path
        checks = [
            {"id": "repo_exists", "ok": path.is_dir(), "detail": str(path)},
            {"id": "atomics_path_exists", "ok": (path / "atomics").is_dir(), "detail": str(path / "atomics")},
            {"id": "invoke_atomic_available", "ok": self.invoke_atomic_available(), "detail": "Invoke-AtomicTest or pwsh module path"},
            {
                "id": "sample_ttp_executable",
                "ok": (path / "atomics" / "T1059" / "T1059.yaml").is_file() or (path / "atomics" / "T1003" / "T1003.yaml").is_file(),
                "detail": "sample Atomic technique YAML present",
            },
        ]
        ok = all(bool(c["ok"]) for c in checks)
        block = self.write_atomic_state(installed=ok, status="ok" if ok else "missing", detail="; ".join(f"{c['id']}={c['ok']}" for c in checks))
        return {"ok": ok, "tool": "atomic", "state": block, "checks": checks}

    def invoke_atomic_available(self) -> bool:
        rc, out = run(["pwsh", "-NoProfile", "-Command", "Get-Command Invoke-AtomicTest -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Name"], timeout=30)
        return rc == 0 and "Invoke-AtomicTest" in out

    def install_atomic(self, *, update_only: bool = False) -> int:
        if dry_run():
            action = "update" if update_only else "install"
            print(f"DRY-RUN: would {action} Atomic Red Team at {self.atomic_path}")
            return 0
        self.tools_dir.mkdir(parents=True, exist_ok=True)
        path = self.atomic_path
        if path.exists() and (path / ".git").is_dir():
            rc, out = run(["git", "pull", "--ff-only"], cwd=path)
        elif update_only:
            print(f"Atomic Red Team repository missing: {path}", file=sys.stderr)
            self.write_atomic_state(installed=False, status="missing", detail="update requested before install")
            return 1
        else:
            rc, out = run(["git", "clone", ATOMIC_REPO_URL, str(path)])
        if rc != 0:
            print(out, file=sys.stderr)
            self.write_atomic_state(installed=False, status="failed", detail=out)
            return rc
        self.install_invoke_atomic_best_effort()
        report = self.verify_atomic()
        self.print_verify(report)
        return 0 if report["ok"] else 1

    def install_invoke_atomic_best_effort(self) -> None:
        if run(["pwsh", "-NoProfile", "-Command", "$PSVersionTable.PSVersion.ToString()"], timeout=20)[0] != 0:
            return
        run(
            [
                "pwsh",
                "-NoProfile",
                "-Command",
                "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; "
                "Install-Module invoke-atomicredteam -Scope CurrentUser -Force -ErrorAction SilentlyContinue",
            ],
            timeout=300,
        )

    def tools_list(self) -> dict[str, Any]:
        state = self.load_state()
        state["caldera"] = self.caldera_state()
        if "atomic" not in state:
            state["atomic"] = self.write_atomic_state(installed=self.atomic_path.is_dir(), status="unknown")
        self.write_state(state)
        return {"ok": True, "state_path": str(self.state_path), "tools": {k: state[k] for k in ("caldera", "atomic") if k in state}}

    def tools_verify(self) -> dict[str, Any]:
        listing = self.tools_list()
        tools = listing["tools"]
        return {"ok": True, "state_path": str(self.state_path), "tools": tools}

    def print_verify(self, report: dict[str, Any]) -> None:
        print("=== Atomic Red Team runtime verify ===")
        for c in report.get("checks", []):
            print(f"[{'PASS' if c.get('ok') else 'FAIL'}] {c.get('id')} {c.get('detail')}")
        print(f"RESULT: {'PASS' if report.get('ok') else 'FAIL'}")


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="XDR Lab runtime tool manager")
    p.add_argument("--xdr-root", default=os.environ.get("XDR_ROOT") or os.environ.get("XDR_BASE") or "/opt/xdr-lab")
    sub = p.add_subparsers(dest="cmd", required=True)
    atomic = sub.add_parser("atomic")
    atomic_sub = atomic.add_subparsers(dest="atomic_cmd", required=True)
    atomic_sub.add_parser("install")
    atomic_sub.add_parser("update")
    atomic_sub.add_parser("verify")
    tools = sub.add_parser("tools")
    tools_sub = tools.add_subparsers(dest="tools_cmd", required=True)
    tools_sub.add_parser("list")
    tools_sub.add_parser("verify")
    return p


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    mgr = ToolRuntime(Path(args.xdr_root).resolve())
    if args.cmd == "atomic":
        if args.atomic_cmd == "install":
            return mgr.install_atomic(update_only=False)
        if args.atomic_cmd == "update":
            return mgr.install_atomic(update_only=True)
        report = mgr.verify_atomic()
        mgr.print_verify(report)
        return 0 if report["ok"] else 1
    if args.cmd == "tools":
        report = mgr.tools_list() if args.tools_cmd == "list" else mgr.tools_verify()
        print(json.dumps(report, indent=2, sort_keys=True))
        return 0
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
