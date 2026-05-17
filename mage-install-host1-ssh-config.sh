#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <host2-troll-name>" >&2
  echo "example: $0 troll-4" >&2
  exit 1
fi

host2=$1

ssh_config_path="${SSH_CONFIG_PATH:-/root/.ssh/config}"

begin_marker="# >>> mage host1 control aliases >>>"
end_marker="# <<< mage host1 control aliases <<<"

mkdir -p "$(dirname "$ssh_config_path")"
chmod 700 "$(dirname "$ssh_config_path")"
touch "$ssh_config_path"
chmod 600 "$ssh_config_path"

tmp_final="$(mktemp)"
trap 'rm -f "$tmp_final"' EXIT

# Preserve existing config and replace only the block managed by this script.
awk -v begin="$begin_marker" -v end="$end_marker" '
  $0 == begin { skip = 1; next }
  $0 == end { skip = 0; next }
  !skip { print }
' "$ssh_config_path" > "$tmp_final"

{
  printf '\n%s\n' "$begin_marker"
  cat <<EOF
Host mage-host-mn
    HostName $host2
    User root
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host mage-cn
    HostName 192.168.122.50
    User mage
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host mage-mn
    HostName 192.168.122.51
    User mage
    ProxyJump mage-host-mn
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
  printf '%s\n' "$end_marker"
} >> "$tmp_final"

install -m 600 "$tmp_final" "$ssh_config_path"

cat <<EOF
Installed Mage Host 1 SSH aliases into $ssh_config_path.

Verify from Host 1:
  ssh mage-host-mn 'hostname'
  ssh mage-cn 'hostname'
  ssh mage-mn 'hostname'
EOF
