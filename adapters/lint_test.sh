#!/bin/sh
# marrow v0 — regression harness for adapters/lint.sh: seeds each violation class and
# asserts the verdict. Must be green before any lint.sh change ships.
set -eu

LINT=$(cd "$(dirname "$0")" && pwd)/lint.sh
ROOT=${TMPDIR:-/tmp}/marrow-lint-test.$$
mkdir -p "$ROOT"
trap 'rm -rf "$ROOT"' EXIT INT TERM
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
ok=0; bad=0; T=

pad() { i=0; while [ "$i" -lt "$1" ]; do echo "- pad $i"; i=$((i + 1)); done; }

fresh() { # fresh [git] — minimal valid instance; with "git", committed as baseline
  T=$ROOT/case-$((ok + bad))
  mkdir -p "$T/plans/archive"
  printf '# State\n\n<!-- Hard cap: 25 lines. -->\n\nall quiet\n' > "$T/STATE.md"
  { echo '# Decisions'; echo
    echo '| Date | Decision | Why / evidence |'; echo '|---|---|---|'
    echo '| 2026-01-01 | adopt X | plan link |'; echo '| 2026-01-02 | drop Y | measured |'
  } > "$T/DECISIONS.md"
  if [ "${1:-}" = git ]; then
    (cd "$T" && git init -q && git add -A &&
      git -c user.name=t -c user.email=t@t commit -qm baseline) >/dev/null
  fi
}

expect() { # expect <0|1> <description>
  want=$1; shift
  if (cd "$T" && sh "$LINT") >/dev/null 2>&1; then got=0; else got=1; fi
  if [ "$got" = "$want" ]; then ok=$((ok + 1)); echo "  ok  $*"
  else bad=$((bad + 1)); echo "  BAD $* — want exit $want, got $got"; fi
}

expect_with() { # expect_with <base> <0|1> <description> — lint.sh with a BASE argument
  base=$1; want=$2; shift 2
  if (cd "$T" && sh "$LINT" "$base") >/dev/null 2>&1; then got=0; else got=1; fi
  if [ "$got" = "$want" ]; then ok=$((ok + 1)); echo "  ok  $*"
  else bad=$((bad + 1)); echo "  BAD $* — want exit $want, got $got"; fi
}

plan() { cat > "$T/plans/archive/p.md"; }
del_row() { sed '5d' "$T/DECISIONS.md" > "$T/.d" && mv "$T/.d" "$T/DECISIONS.md"; }

VH='## Verify — the gate

| Check | How | Evidence |
|---|---|---|'

# baseline
fresh;     expect 0 "clean instance, no git"
fresh git; expect 0 "clean instance, committed"

# 0 — a live instance must carry STATE.md
fresh; rm "$T/STATE.md"
expect 1 "plans/ and DECISIONS.md present but STATE.md missing"

# 1 — STATE.md cap
fresh; { printf '# State\n\n<!-- Hard cap: 25 lines. -->\n'; pad 23; } > "$T/STATE.md"
expect 1 "26 lines over a 25 cap"
fresh; { printf '# State\n\n<!-- Hard cap: 25 lines. -->\n'; pad 22; printf -- '- unterminated'; } > "$T/STATE.md"
expect 1 "26 physical lines, last one unterminated"
fresh; printf '# State\nno cap declared\n' > "$T/STATE.md"
expect 1 "header missing the 'Hard cap: N lines' phrase"
fresh; { printf '# State\n\n<!-- Hard cap: 30 lines. -->\n'; pad 25; } > "$T/STATE.md"
expect 0 "28 lines under a raised 30-line cap — cap is parsed, not hardcoded"

# 2 — archived-plan evidence gate
fresh; plan <<EOF
# Plan: p

$VH
| Fast gate | cmd | output pasted |
| Behavior | drive the flow | log excerpt |
EOF
expect 0 "archived plan, every Evidence cell filled"
fresh; plan <<EOF
$VH
| Fast gate | cmd | |
EOF
expect 1 "blank Evidence cell, trailing pipe"
fresh; plan <<EOF
$VH
| Fast gate | cmd |
EOF
expect 1 "Evidence cell missing from the row"
fresh; plan <<EOF
$VH
| Fast gate | cmd | done
EOF
expect 0 "no trailing pipe, evidence present"
fresh; plan <<EOF
$VH
| Fast gate | cmd \| tail -1 | |
EOF
expect 1 "escaped pipe inside a cell; Evidence still blank"
fresh; plan <<EOF
# Plan: p

nothing to see
EOF
expect 1 "no Verify section at all"
fresh; plan <<EOF
$VH
EOF
expect 1 "Verify table with header but no data rows"
fresh; plan <<EOF
$VH
| Fast gate | cmd | abandoned |
| Behavior | drive | abandoned |
EOF
expect 0 "abandoned per CLOSEOUT: cells filled with 'abandoned'"
fresh; mkdir -p "$T/plans/archive/2026"; cat > "$T/plans/archive/2026/x.md" <<EOF
$VH
| Fast gate | cmd | |
EOF
expect 1 "blank Evidence cell in a nested archive subdirectory"

# 3 — DECISIONS.md append-only
fresh git; del_row
expect 1 "row deleted, unstaged"
fresh git; del_row; (cd "$T" && git add DECISIONS.md)
expect 1 "row deleted, staged, no archive"
fresh git; sed 's/adopt X/adopt Z/' "$T/DECISIONS.md" > "$T/.d" && mv "$T/.d" "$T/DECISIONS.md"
expect 1 "row edited in place"
fresh git; sed -n '5,6p' "$T/DECISIONS.md" > "$T/.rows"
sed '5,6d' "$T/DECISIONS.md" > "$T/.d" && mv "$T/.d" "$T/DECISIONS.md"
mkdir -p "$T/decisions" && mv "$T/.rows" "$T/decisions/archive-2026.md"
expect 0 "full epoch move — every row verbatim in decisions/archive-2026.md"
fresh git; row=$(sed -n '5p' "$T/DECISIONS.md"); del_row
mkdir -p "$T/decisions"; printf '%s\n' "$row" > "$T/decisions/archive-2026.md"
expect 1 "single-row removal with an archive copy — partial epoch move"
fresh git; del_row; mkdir -p "$T/decisions"
printf '| 1999-01-01 | unrelated | x |\n' > "$T/decisions/archive-2026.md"
(cd "$T" && git add decisions)
expect 1 "archive staged but the removed row is not in it"
fresh git; printf '| 2026-01-03 | new | appended |\n' >> "$T/DECISIONS.md"
expect 0 "pure append"
fresh; { echo '# Decisions'; echo
  echo '| Date | Decision | Why / evidence |'; echo '|---|---|---|'
  echo '| YYYY-MM-DD | <your first entry replaces this row> | <why — plan link or measurement> |'
} > "$T/DECISIONS.md"
(cd "$T" && git init -q && git add -A && git -c user.name=t -c user.email=t@t commit -qm baseline) >/dev/null
sed 's/^| YYYY-MM-DD .*/| 2026-01-01 | adopt X | plan link |/' "$T/DECISIONS.md" > "$T/.d" && mv "$T/.d" "$T/DECISIONS.md"
expect 0 "placeholder row replaced by the first real entry"
fresh git; sed 's/adopt X/adopt Z/' "$T/DECISIONS.md" > "$T/.d" && mv "$T/.d" "$T/DECISIONS.md"
(cd "$T" && git add -A && git -c user.name=t -c user.email=t@t commit -qm reword) >/dev/null
expect 0 "reword already committed — invisible to the no-arg HEAD diff"
expect_with HEAD~1 1 "same committed reword caught with BASE=HEAD~1"

echo "lint-test: $ok ok, $bad failing"
[ "$bad" -eq 0 ]
