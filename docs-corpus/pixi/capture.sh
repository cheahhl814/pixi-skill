#!/bin/bash
# Regenerate cli-reference.md verbatim from the installed pixi binary.
#
# The subcommand list is DERIVED from `pixi --help` at capture time, not hardcoded
# — pixi adds subcommands every release (0.81 -> 0.83 added auth, config, exec,
# import, reinstall, upgrade) and a hardcoded list silently goes stale. `pixi
# global` gets a second-level capture because the global-vs-project decision is
# the one agents get wrong most often.
set -euo pipefail
cd "$(dirname "$0")"
OUT=cli-reference.md

# Top-level subcommands, parsed from the "Commands:" block of `pixi --help`.
mapfile -t SUBS < <(
  pixi --help 2>&1 \
    | sed -n '/^Commands:/,/^Options:/p' \
    | grep -oE '^  [a-z][a-z-]+' \
    | tr -d ' ' \
    | grep -vE '^(help)$'
)

# `pixi global` subcommands.
mapfile -t GLOBAL_SUBS < <(
  pixi global --help 2>&1 \
    | sed -n '/^Commands:/,/^Options:/p' \
    | grep -oE '^  [a-z][a-z-]+' \
    | tr -d ' ' \
    | grep -vE '^(help)$'
)

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
  for sub in "${SUBS[@]}"; do
    echo "## pixi $sub --help"
    echo '```'
    pixi "$sub" --help 2>&1
    echo '```'
    echo ""
  done
  for sub in "${GLOBAL_SUBS[@]}"; do
    echo "## pixi global $sub --help"
    echo '```'
    pixi global "$sub" --help 2>&1
    echo '```'
    echo ""
  done
} > "$OUT"
echo "wrote $OUT ($(wc -l < "$OUT") lines, $(grep -c '^## ' "$OUT") sections; ${#SUBS[@]} top-level + ${#GLOBAL_SUBS[@]} global subcommands)"
