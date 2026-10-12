#!/usr/bin/env bash
# bankai installer — copies the canon (master + children) next to your agent's other skills.
# Two ways to run it:
#   1) from a clone:      ./install.sh [target-dir]
#   2) one-liner (no git, no node — only curl + tar):
#      curl -fsSL https://raw.githubusercontent.com/Ahmed-OC/bankai/main/install.sh | bash [target-dir]
set -euo pipefail
REPO="Ahmed-OC/bankai"
BRANCH="main"

if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/bankai/SKILL.md" ]; then
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  echo "Downloading bankai…"
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TMP"
  ROOT="$TMP/bankai-$BRANCH"
fi

if [ -n "${1:-}" ]; then
  TARGET="$1"
else
  # project-level first, then home-level, first existing wins
  for CAND in ".agents/skills" ".claude/skills" ".codex/skills" ".cursor/skills" \
              "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.cursor/skills"; do
    if [ -d "$CAND" ]; then TARGET="$CAND"; break; fi
  done
  if [ -z "${TARGET:-}" ]; then
    echo "No skills directory found (.agents/skills, .claude/skills, …)."
    echo "Create one (mkdir -p .agents/skills) or pass a target: install.sh <dir>"
    exit 1
  fi
fi

mkdir -p "$TARGET"
COUNT=0
install_one() {  # $1 = source dir
  local NAME; NAME="$(basename "$1")"
  rm -rf "$TARGET/$NAME"
  cp -r "$1" "$TARGET/$NAME"
  COUNT=$((COUNT+1))
}
install_one "$ROOT/bankai"                       # the entry point
for DIR in "$ROOT"/skills/*/; do install_one "$DIR"; done   # the children
cp "$ROOT/skills/_CONVENTIONS.md" "$TARGET/" 2>/dev/null || true
echo "Installed $COUNT skills into: $TARGET"
echo "Start with: bankai (it routes to the children automatically)."
