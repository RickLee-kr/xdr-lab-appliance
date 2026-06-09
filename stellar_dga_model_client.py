#!/usr/bin/env python3
"""
Stellar PoC — DGA Model client (xdr.ooo validated pattern).
Phase 1: random DGA-like FQDNs under *.xdr.ooo → NXDOMAIN
Phase 2: random DGA-like FQDNs under *.live.xdr.ooo → resolvable A records
"""
from __future__ import annotations

import argparse
import os
import random
import socket
import struct
import sys
import time
from typing import List, Optional, Tuple

DGA_BASE_DOMAIN_DEFAULT = "xdr.ooo"
PHASE1_COUNT_DEFAULT = 500
PHASE2_COUNT_DEFAULT = 30
QTYPE_A = 1
PROGRESS_PHASE1 = 50
PROGRESS_PHASE2 = 5
SLEEP_MIN = 0.002
SLEEP_MAX = 0.015
TSV_HEADER = (
    "timestamp\trun_id\tmodule\tstage\ttarget\taction\tartifact\t"
    "status\texit_code\tevidence_value\tsource\n"
)


def iso_ts() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


def log_line(msg: str) -> None:
    print(msg, flush=True)


def encode_qname(fqdn: str) -> bytes:
    out = bytearray()
    for part in fqdn.lower().split("."):
        if not part or len(part) > 63:
            raise ValueError(f"invalid label in {fqdn}")
        out.append(len(part))
        out.extend(part.encode("ascii"))
    out.append(0)
    return bytes(out)


def build_dns_query(fqdn: str, qtype: int = QTYPE_A) -> Tuple[int, bytes]:
    txn_id = random.randint(0, 65535)
    header = struct.pack("!HHHHHH", txn_id, 0x0100, 1, 0, 0, 0)
    question = encode_qname(fqdn) + struct.pack("!HH", qtype, 1)
    return txn_id, header + question


def parse_dns_response(packet: bytes) -> str:
    if len(packet) < 12:
        return "error"
    flags = struct.unpack("!H", packet[2:4])[0]
    rcode = flags & 0x0F
    ancount = struct.unpack("!H", packet[6:8])[0]
    if rcode == 3:
        return "nxdomain"
    if rcode == 0 and ancount > 0:
        return "resolved"
    if rcode == 0:
        return "noanswer"
    return "error"


def read_resolver_from_resolv_conf() -> Optional[str]:
    try:
        with open("/etc/resolv.conf", encoding="utf-8") as fh:
            for line in fh:
                parts = line.split()
                if len(parts) >= 2 and parts[0] == "nameserver":
                    ip = parts[1].strip()
                    try:
                        socket.inet_aton(ip)
                        return ip
                    except OSError:
                        continue
    except OSError:
        pass
    return None


def default_resolver() -> str:
    env = os.environ.get("DGA_MODEL_RESOLVER", "").strip()
    if env and env != "system":
        try:
            socket.inet_aton(env)
            return env
        except OSError:
            pass
    resolved = read_resolver_from_resolv_conf()
    if resolved:
        return resolved
    return "127.0.0.53"


def rand_label(min_len: int = 10, max_len: int = 16) -> str:
    n = random.randint(min_len, max_len)
    alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
    return "".join(random.choice(alphabet) for _ in range(n))


def gen_phase1_fqdn(base_domain: str) -> str:
    return f"{rand_label()}.{base_domain}"


def gen_phase2_fqdn(base_domain: str) -> str:
    return f"{rand_label()}.{base_domain}"


def phase2_suffix(base_domain: str) -> str:
    return f"live.{base_domain}"


class DgaEventWriter:
    def __init__(self, path: Optional[str], source: str = "dga_model_client") -> None:
        self.path = (path or "").strip() or None
        self.source = source
        self._fh = None
        self.rows = 0

    def bootstrap(self, run_id: str, base_domain: str) -> None:
        if not self.path:
            return
        parent = os.path.dirname(self.path)
        if parent:
            os.makedirs(parent, exist_ok=True)
        ts = iso_ts()
        with open(self.path, "w", encoding="utf-8") as fh:
            fh.write(TSV_HEADER)
            fh.write(
                f"{ts}\t{run_id}\tDGA\tdga_model_client\t-\tmeta\t"
                f"start\tmeta\t0\tstart|{base_domain}|{run_id}\t{self.source}\n"
            )
            fh.flush()
            os.fsync(fh.fileno())
        self._fh = open(self.path, "a", encoding="utf-8")

    def close(self) -> None:
        if self._fh:
            self._fh.flush()
            os.fsync(self._fh.fileno())
            self._fh.close()
            self._fh = None

    def append(
        self,
        run_id: str,
        resolver: str,
        domain: str,
        phase: str,
        qtype: str,
        status: str,
        base_domain: str,
    ) -> None:
        if not self._fh:
            return
        ts = iso_ts()
        tld = base_domain
        evidence = f"{domain}|{qtype}|{phase}|{base_domain}"
        row = (
            f"{ts}\t{run_id}\tDGA\tdga_model_client\t{resolver}\tquery\t"
            f"domain\t{status}\t0\t{evidence}\t{self.source}\n"
        )
        self._fh.write(row)
        self.rows += 1


def dns_query_with_response(
    sock: socket.socket,
    resolver: str,
    fqdn: str,
    timeout: float = 2.0,
) -> str:
    txn_id, packet = build_dns_query(fqdn, QTYPE_A)
    sock.settimeout(timeout)
    try:
        sock.sendto(packet, (resolver, 53))
        data, _addr = sock.recvfrom(4096)
    except socket.timeout:
        return "timeout"
    except OSError:
        return "error"
    if len(data) >= 2 and struct.unpack("!H", data[0:2])[0] != txn_id:
        return "error"
    return parse_dns_response(data)


def run_phase(
    phase: str,
    count: int,
    suffix: str,
    base_domain: str,
    resolver: str,
    run_id: str,
    writer: DgaEventWriter,
    dry_run: bool,
    stats: dict,
    sample_holder: dict,
) -> None:
    phase_num = "1" if phase == "nx" else "2"
    log_line(f"DGA_PHASE{phase_num}_START phase={phase} count={count} suffix={suffix}")
    sock: Optional[socket.socket] = None
    if not dry_run:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    sent = 0
    nx_or_res = 0
    for i in range(1, count + 1):
        if phase == "nx":
            fqdn = gen_phase1_fqdn(base_domain)
        else:
            fqdn = gen_phase2_fqdn(suffix)

        writer.append(run_id, resolver, fqdn, phase, "A", "generated", base_domain)
        writer.append(run_id, resolver, fqdn, phase, "A", "sent", base_domain)
        sent += 1
        stats["sent"] += 1

        if dry_run:
            result = "nxdomain" if phase == "nx" else "resolved"
        else:
            assert sock is not None
            result = dns_query_with_response(sock, resolver, fqdn)

        if result == "nxdomain":
            stats["nx_nxdomain"] += 1
            writer.append(run_id, resolver, fqdn, phase, "A", "nxdomain", base_domain)
        elif result == "resolved":
            stats["resolvable_resolved"] += 1
            writer.append(run_id, resolver, fqdn, phase, "A", "response", base_domain)
        elif result == "timeout":
            stats["timeout"] += 1
            writer.append(run_id, resolver, fqdn, phase, "A", "timeout", base_domain)
        else:
            stats["error"] += 1
            writer.append(run_id, resolver, fqdn, phase, "A", "error", base_domain)

        if phase == "nx" and result == "nxdomain":
            nx_or_res += 1
        elif phase == "res" and result == "resolved":
            nx_or_res += 1

        if i == 1 and "sample" not in sample_holder:
            sample_holder["sample"] = fqdn
            log_line(f"DGA_PACKET_EVIDENCE sample_fqdn={fqdn} phase={phase}")

        interval = PROGRESS_PHASE1 if phase == "nx" else PROGRESS_PHASE2
        if i % interval == 0 or i == count:
            log_line(
                f"DGA_PHASE{phase_num}_PROGRESS phase={phase} sent={sent} "
                f"{'nx_nxdomain' if phase == 'nx' else 'resolvable_resolved'}={nx_or_res}"
            )
        time.sleep(random.uniform(SLEEP_MIN, SLEEP_MAX))

    if sock:
        sock.close()

    if phase == "nx":
        stats["nx_sent"] = sent
    else:
        stats["resolvable_sent"] = sent

    log_line(
        f"DGA_PHASE{phase_num}_DONE phase={phase} sent={sent} "
        f"{'nx_nxdomain' if phase == 'nx' else 'resolvable_resolved'}={nx_or_res}"
    )


def run_client(args: argparse.Namespace) -> int:
    base_domain = args.base_domain
    nx_count = args.nx_count
    res_count = args.resolvable_count
    run_id = args.run_id
    dry_run = args.dry_run_sot
    resolver = default_resolver() if args.resolver in ("", "system") else args.resolver

    log_line(f"DGA_TARGET_DOMAIN base_domain={base_domain} resolver={resolver}")

    writer = DgaEventWriter(args.event_file)
    if args.event_file:
        writer.bootstrap(run_id, base_domain)

    stats = {
        "nx_sent": 0,
        "nx_nxdomain": 0,
        "resolvable_sent": 0,
        "resolvable_resolved": 0,
        "sent": 0,
        "timeout": 0,
        "error": 0,
    }
    sample_holder: dict = {}

    run_phase(
        "nx",
        nx_count,
        base_domain,
        base_domain,
        resolver,
        run_id,
        writer,
        dry_run,
        stats,
        sample_holder,
    )
    run_phase(
        "res",
        res_count,
        phase2_suffix(base_domain),
        base_domain,
        resolver,
        run_id,
        writer,
        dry_run,
        stats,
        sample_holder,
    )

    writer.close()

    nx_sent = stats["nx_sent"]
    nx_nx = stats["nx_nxdomain"]
    res_sent = stats["resolvable_sent"]
    res_res = stats["resolvable_resolved"]
    success_rate = 0.0
    total_outcomes = nx_nx + res_res
    total_sent = nx_sent + res_sent
    if total_sent > 0:
        success_rate = total_outcomes * 100.0 / total_sent

    full_success = int(nx_nx >= 500 and res_res >= 20)
    success = int(nx_nx >= 300 and res_res >= 10)

    log_line(
        f"DGA_MODEL_SUMMARY base_domain={base_domain} nx_sent={nx_sent} "
        f"nx_nxdomain={nx_nx} resolvable_sent={res_sent} "
        f"resolvable_resolved={res_res} success_rate={success_rate:.1f} "
        f"same_base_domain={base_domain} success={success} full_success={full_success} "
        f"timeout={stats['timeout']} error={stats['error']} "
        f"sample_fqdn={sample_holder.get('sample', 'none')}"
    )
    return 0


def args_from_env() -> Optional[argparse.Namespace]:
    run_id = os.environ.get("DGA_MODEL_RUN_ID", "").strip()
    if not run_id:
        return None
    ns = argparse.Namespace()
    ns.run_id = run_id
    ns.base_domain = os.environ.get("DGA_MODEL_BASE_DOMAIN", DGA_BASE_DOMAIN_DEFAULT)
    ns.nx_count = int(os.environ.get("DGA_MODEL_NX_COUNT", str(PHASE1_COUNT_DEFAULT)))
    ns.resolvable_count = int(os.environ.get("DGA_MODEL_RESOLVABLE_COUNT", str(PHASE2_COUNT_DEFAULT)))
    ns.resolver = os.environ.get("DGA_MODEL_RESOLVER", "system")
    ns.dry_run_sot = os.environ.get("DGA_MODEL_DRY_RUN_SOT", "").lower() in ("1", "yes", "true")
    ns.event_file = os.environ.get("DGA_MODEL_EVENT_FILE", "").strip() or None
    return ns


def main() -> int:
    env_args = args_from_env()
    if env_args is not None:
        args = env_args
    else:
        p = argparse.ArgumentParser(description="DGA Model client (xdr.ooo NXDOMAIN + resolvable)")
        p.add_argument("--run-id", default="run")
        p.add_argument("--base-domain", default=DGA_BASE_DOMAIN_DEFAULT)
        p.add_argument("--nx-count", type=int, default=PHASE1_COUNT_DEFAULT)
        p.add_argument("--resolvable-count", type=int, default=PHASE2_COUNT_DEFAULT)
        p.add_argument("--resolver", default="system")
        p.add_argument("--dry-run-sot", action="store_true")
        p.add_argument("--event-file", default="")
        args = p.parse_args()
        args.event_file = (args.event_file or "").strip() or None

    return run_client(args)


if __name__ == "__main__":
    sys.exit(main())
