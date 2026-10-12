#!/usr/bin/env bash
# bankai installer — copies the canon next to your agent's other skills.
# Two ways to run it:
#   1) from a clone:      ./install.sh [target-dir]
#   2) one-liner (no git, no node — only curl + tar):
#      curl -fsSL https://raw.githubusercontent.com/Ahmed-OC/bankai/main/install.sh | bash [target-dir]
set -euo pipefail
REPO="Ahmed-OC/bankai"
BRANCH="main"

if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/skills/bankai/SKILL.md" ]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  echo "Downloading bankai…"
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TMP"
  SRC="$TMP/bankai-$BRANCH/skills"
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
for DIR in "$SRC"/*/; do
  NAME="$(basename "$DIR")"
  rm -rf "$TARGET/$NAME"
  cp -r "$DIR" "$TARGET/$NAME"
  COUNT=$((COUNT+1))
done
cp "$SRC/_CONVENTIONS.md" "$TARGET/" 2>/dev/null || true
echo "Installed $COUNT skills into: $TARGET"
echo "Start with: bankai (it routes to the children automatically)."
