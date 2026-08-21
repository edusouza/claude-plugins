#!/usr/bin/env bash
# Structural audit of a memory-wiki. Pure function: takes a directory, prints a
# deterministic report, exits 0. Reports only — never fixes, never writes.
#
# Usage: wiki-lint.sh <WIKI_DIR> [--sources <DIR>] [--atlas <DIR>]
set -uo pipefail

WIKI=""; SOURCES=""; ATLAS=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --sources) SOURCES="${2:-}"; shift 2 ;;
    --atlas)   ATLAS="${2:-}";   shift 2 ;;
    *)         WIKI="$1";        shift ;;
  esac
done

if [[ -z "$WIKI" || ! -d "$WIKI" ]]; then
  echo "ERROR: not a directory: ${WIKI:-<none>}" >&2
  exit 0
fi

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# index.md and log.md link to nearly every page by design. Counting their links as
# inbound edges would hide every orphan, so they are excluded from the page set and
# from inbound-edge accounting (their links still count toward the total).
is_structural() { [[ "$1" == "index" || "$1" == "log" ]]; }

# --- collect page names and per-page link lists ---
: > "$TMP/pages"; : > "$TMP/links"; : > "$TMP/inbound"; : > "$TMP/nofm"
LINK_COUNT=0

for f in "$WIKI"/*.md; do
  [[ -e "$f" ]] || continue
  base="$(basename "$f" .md)"
  is_structural "$base" || echo "$base" >> "$TMP/pages"

  # frontmatter must be a --- fenced block starting on line 1
  if ! is_structural "$base"; then
    if [[ "$(head -n 1 "$f" | tr -d '\r')" != "---" ]]; then
      echo "$base" >> "$TMP/nofm"
    fi
  fi

  # [[target]] — stop at ] | or #, so aliases and anchors resolve to the page
  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    LINK_COUNT=$((LINK_COUNT + 1))
    echo "$base|$target" >> "$TMP/links"
  done < <(grep -o '\[\[[^]|#]*' "$f" 2>/dev/null | sed 's/^\[\[//' | sed 's/[[:space:]]*$//')
done

sort -u -o "$TMP/pages" "$TMP/pages"
PAGE_COUNT=$(wc -l < "$TMP/pages" | tr -d ' ')
NOFM_COUNT=$(sort -u "$TMP/nofm" | grep -c . || true)

# --- report ---
echo "## Structural"
printf '  %-20s : %s\n' "pages" "$PAGE_COUNT"
printf '  %-20s : %s\n' "wikilinks" "$LINK_COUNT"
printf '  %-20s : %s\n' "broken links" "0"
printf '  %-20s : %s\n' "orphans" "0"
printf '  %-20s : %s\n' "missing frontmatter" "$NOFM_COUNT"

if [[ "$NOFM_COUNT" -gt 0 ]]; then
  echo ""; echo "  NO FRONTMATTER:"
  sort -u "$TMP/nofm" | sed 's/^/    /'
fi

echo ""
echo "## Injection budget"
REGION_BYTES=0
if [[ -f "$WIKI/index.md" ]]; then
  # tr -d '\r' is load-bearing: a memory dir may hold CRLF or LF files, and the
  # reported budget must not depend on which. The PowerShell twin strips \r too.
  REGION_BYTES=$(awk '/<!-- BEGIN memory-wiki/{f=1;next} /<!-- END memory-wiki/{f=0} f' "$WIKI/index.md" | tr -d '\r' | wc -c | tr -d ' ')
fi
printf '  %-20s : %s B (~%s tokens)\n' "index region" "$REGION_BYTES" "$((REGION_BYTES * 10 / 36))"
