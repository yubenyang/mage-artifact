#!/usr/bin/env bash
set -euo pipefail

role=${1:?usage: $0 host1|cn|mn}

case "$role" in
  host1) mage_scripts="$MIND_ROOT/scripts/vmhost" ;;
  cn) mage_scripts="$MIND_ROOT/scripts/cn" ;;
  mn) mage_scripts="$MIND_ROOT/scripts/mn" ;;
  *) echo "usage: $0 host1|cn|mn" >&2; exit 1 ;;
esac

for script in "$mage_scripts"/*; do
  sudo ln -sf "$script" /usr/local/bin/
done

echo "Installed Mage helper scripts for role: $role"
