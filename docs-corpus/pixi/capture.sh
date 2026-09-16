#!/bin/bash
# Regenerate cli-reference.md verbatim from the installed pixi binary.
set -euo pipefail
cd "$(dirname "$0")"
OUT=cli-reference.md
{
  echo "# pixi CLI Reference"
  echo ""
  echo "Captured verbatim from \`pixi --help\` and subcommand --help output. pixi version: $(pixi --version)."
  echo "Captured: $(date +%F)"
  echo ""
  echo "## pixi --help"
  echo '```'
  pixi --help 2>&1
  echo '```'
  echo ""
  for sub in add remove init task run shell shell-hook install lock update list search tree info workspace global clean upload publish self-update completion; do
    echo "## pixi $sub --help"
    echo '```'
    pixi "$sub" --help 2>&1
    echo '```'
    echo ""
  done
} > "$OUT"
echo "wrote $OUT ($(wc -l < "$OUT") lines, $(grep -c '^## ' "$OUT") sections)"