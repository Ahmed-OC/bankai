#!/usr/bin/env bash
# ui-ux-canon installer — copies the canon next to your agent's other skills.
# Usage: ./install.sh [target-dir]
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/skills"

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
    echo "Create one (mkdir -p .agents/skills) or pass a target: ./install.sh <dir>"
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
echo "Start with: desengs-ui-ux-master (it routes to the children automatically)."
