# Sliver Integration Preparation

This document is a preparation scaffold only. XDR Lab does not install or start
Sliver yet.

## Role

Sliver is a future scenario engine for controlled C2-style exercises. In this
lab it must be treated as an operator-managed runtime tool, not Golden Image
content and not part of the Stellar sensor VM.

## Architecture

- `aella_cli lab tools ...` tracks runtime tool state under
  `/opt/xdr-lab/runtime/state/tools.json`.
- Future Sliver binaries and server state belong under
  `/opt/xdr-lab/runtime/tools/sliver`.
- Scenario execution must target attack VMs such as `victim-linux` and
  `windows-victim`. `sensor-vm` remains an observer-only VM.
- The Stellar sensor observes mirrored traffic through OVS; it must not host C2
  services or implants.

## Reverse NAT Strategy

Sliver listener exposure must use declared lab reverse-NAT entries or a future
explicit Sliver NAT contract. No scenario may add ad hoc host firewall rules.
Guest callbacks should stay inside `10.10.10.0/24` unless an operator supplies a
documented, logged external route override.

## Multiplayer C2 Separation

Sliver multiplayer services should be isolated from CALDERA. Operator API,
multiplayer, and implant listener ports must be separate from CALDERA's
`8888/tcp` and from Stellar sensor management ports. Credentials and operator
profiles must be stored outside repository JSON.

## Safety Constraints

- No implant build or tasking is performed by the current appliance.
- No Sliver package or binary is baked into the Golden Image.
- No production egress is allowed without an explicit scenario-level override.
- API keys, multiplayer credentials, and implant profiles must never be logged
  or committed.

## Snapshot-Before Policy

Any future Sliver-backed live scenario must require `--snapshot-before` by
default for attack targets. Operators must verify snapshot state before tasking
and must preserve post-run artifacts before reverting.

## Cleanup Requirements

Cleanup must stop Sliver jobs/listeners created for the run, remove staged
payloads from victim VMs, record remaining sessions, and document whether
snapshots were reverted. Cleanup must not destroy unrelated lab VMs or flush
host firewall state.

## Config Scaffold

The disabled scaffold lives in `config/tool-runtime.json`:

```json
{
  "sliver": {
    "enabled": false,
    "install_path": "/opt/xdr-lab/runtime/tools/sliver",
    "server_port": 31337
  }
}
```
