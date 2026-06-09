#!/usr/bin/env bash
# Optional host packages for victim-linux deploy validation (password SSH via sshpass).
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

if command -v sshpass >/dev/null 2>&1; then
  echo "sshpass already installed: $(command -v sshpass)"
  exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y sshpass
  echo "Installed sshpass via apt-get"
  exit 0
fi

if command -v dnf >/dev/null 2>&1; then
  dnf install -y sshpass
  echo "Installed sshpass via dnf"
  exit 0
fi

if command -v yum >/dev/null 2>&1; then
  yum install -y sshpass
  echo "Installed sshpass via yum"
  exit 0
fi

echo "ERROR: no package manager found to install sshpass." >&2
exit 1
