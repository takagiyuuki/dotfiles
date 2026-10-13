#!/usr/bin/env bash
# Deploy root-owned files that home-manager cannot manage on non-NixOS Linux.
# Each layer under hosts/generic-linux mirrors /etc: common is always applied,
# wsl is layered on top under WSL.
#
#   bin/install-etc.sh
#   DRY_RUN=1 bin/install-etc.sh  # print actions without applying
set -euo pipefail

REPO="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
BASE="$REPO/hosts/generic-linux"

if [[ -e /etc/NIXOS ]]; then
  echo 'error: NixOS detected; use nixos-rebuild instead' >&2
  exit 1
fi

run() {
  if [[ -n "${DRY_RUN:-}" ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

ROOTS=("$BASE/common")
if grep -qi microsoft /proc/sys/kernel/osrelease; then
  ROOTS+=("$BASE/wsl")
fi

for root in "${ROOTS[@]}"; do
  [[ -d "$root" ]] || {
    printf 'error: missing %s\n' "$root" >&2
    exit 1
  }
  while IFS= read -r -d '' src; do
    run sudo install -D -m 0644 "$src" "/etc/${src#"$root"/}"
  done < <(find "$root" -type f -print0)
done

run sudo systemctl restart nix-daemon

cat <<'EOF'

/etc files applied.
Under WSL, run 'wsl.exe --shutdown' from Windows to apply /etc/wsl.conf.
EOF
