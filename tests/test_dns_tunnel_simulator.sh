#!/usr/bin/env bash
# Legacy entry — DNS Tunnel simulator replaced by file client
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/test_dns_tunnel_file_client.sh" "$@"
