#!/bin/sh
# marrow v0 — mechanical check of the invariants the docs cannot self-enforce.
# Run from the repo root; regression harness: sh adapters/lint_test.sh.
# Wire as a hook: printf 'sh adapters/lint.sh\n' > .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
# CI: sh adapters/lint.sh origin/main — check 3 diffs DECISIONS.md against that base instead of HEAD.
set -eu

BASE=${1:-HEAD}

fail() { echo "marrow-lint: $1" >&2; exit 1; }

# 0. A live instance — plans/ or DECISIONS.md present — must carry STATE.md.
if [ -d plans ] || [ -f DECISIONS.md ]; then
  [ -f STATE.md ] || fail "STATE.md missing"
fi

# 1. STATE.md hard cap — the header owns the number; a missing phrase fails loud.
if [ -f STATE.md ]; then
  cap=$(sed -n 's/.*Hard cap: *\([0-9]\{1,\}\) lines.*/\1/p' STATE.md | head -n 1)
  [ -n "$cap" ] || fail "STATE.md header must declare 'Hard cap: N lines'"
  lines=$(awk 'END { print NR }' STATE.md)
  [ "$lines" -le "$cap" ] || fail "STATE.md is $lines lines (cap $cap) — regenerate, don't append"
fi

# 2. Archived plans are evidence-complete: a Verify section with an Evidence column,
#    at least one data row, and no blank Evidence cell (abandoned plans write `abandoned`).
find plans/archive -name '*.md' 2>/dev/null | while IFS= read -r plan; do
  msg=$(awk '
    /^## Verify/ { insec = 1; seen = 1; next }
    /^## /       { insec = 0 }
    {
      if (!insec || $0 !~ /^\|/ || $0 ~ /^[| :-]+$/) next
      line = $0; gsub(/\\[|]/, "\001", line)   # escaped pipes are content, not column breaks
      n = split(line, cell, "|")
      if (!ecol) { for (i = 1; i <= n; i++) if (cell[i] ~ /^[[:blank:]]*Evidence[[:blank:]]*$/) ecol = i; next }
      rows++
      if (cell[ecol] ~ /^[[:blank:]]*$/) { bad++; print "  row lacks evidence: " $0 }
    }
    END {
      if (!seen)      print "  no \"## Verify\" section"
      else if (!ecol) print "  Verify table missing an Evidence column"
      else if (!rows) print "  Verify table has no data rows"
      exit (bad || !seen || !ecol || !rows) ? 1 : 0
    }' "$plan") || fail "$plan fails the evidence gate:
$msg"
done

# 3. DECISIONS.md is append-only: any row leaving it — staged or not — must reappear
#    verbatim in decisions/archive-*.md (CLOSEOUT step 8's epoch move).
if git cat-file -e "$BASE":DECISIONS.md 2>/dev/null; then
  git diff "$BASE" -- DECISIONS.md | sed -n 's/^-//p' | grep '^|' | grep -vF '| YYYY-MM-DD |' |
  while IFS= read -r row; do
    grep -qxF -- "$row" decisions/archive-*.md 2>/dev/null ||
      fail "DECISIONS.md row removed without a verbatim archive copy: $row"
  done
  # Epoch moves are all-or-nothing: once any dated row leaves, none may stay behind.
  if git diff "$BASE" -- DECISIONS.md | sed -n 's/^-//p' | grep -q '^| *[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} *|'; then
    ! grep -q '^| *[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} *|' DECISIONS.md 2>/dev/null ||
      fail "DECISIONS.md partial removal — epoch moves take every row"
  fi
fi

echo "marrow-lint: ok"
