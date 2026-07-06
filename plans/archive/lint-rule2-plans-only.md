# Plan: lint-rule2-plans-only

<!-- marrow v0 — written for an executor with NO other context: fresh session, this file + AGENTS.md only.
     Trivial tasks don't get plans. Risky-novel work fills Spec before Tasks. -->

**Intent:** Scope adapters/lint.sh rule 2 (archived-plan evidence gate) to actual plans so non-plan provenance docs may live in plans/archive/ — unblocking the v3 closeout's mandated archival of upgrade-handoff-2026-07.md, currently held at repo root by a STATE.md-recorded blocker (disposition chosen by human 2026-07-05: scope the lint, don't relocate the doc or dress it as a plan).
**Class:** multi-file

## Success criteria (must be TRUE at close)

1. upgrade-handoff-2026-07.md sits in plans/archive/ and the pre-commit gate accepted the move.
2. The evidence gate still bites real plans: a file with `## Tasks` and no `## Verify`, or with a blank Evidence cell, fails lint — proven by lint_test.sh cases that go red against the unpatched lint.sh.
3. The divergence of adapters/lint.sh from the vendored marrow v0.2.0 copy is recorded in DECISIONS.md (human-approved 2026-07-05; candidate upstream diff for marrow).

## Context

- Files / entry points: adapters/lint.sh (rule 2, the `find plans/archive` + awk block, lines ~25–46); adapters/lint_test.sh (section `# 2 — archived-plan evidence gate`, `plan`/`expect` helpers); upgrade-handoff-2026-07.md (at repo root); STATE.md (carries the blocker to remove).
- Predicate (decided; the trap it avoids): enforce rule 2 when the file has a `## Verify` **or** `## Tasks` section; skip only when it has **neither**. Skip-if-no-Tasks alone would exempt every existing `$VH` harness fixture (they carry Verify only) and silently un-gate Verify-bearing docs.
- awk sketch: add `tasks` flag rule `/^## Tasks/ { tasks = 1 }` between the `/^## Verify/` and `/^## /` rules; in END, first line becomes `if (!seen && !tasks) exit 0` (non-plan → skip silently), rest unchanged.
- Binding constraints (from AGENTS.md / DECISIONS.md / this session):
  - Editing the vendored adapter is human-approved (2026-07-05, blocker disposition) — this plan is that approval's paper trail. `marrow/` itself stays untouched.
  - POSIX sh + portable awk only; lint_test.sh must be green before any lint.sh change ships (its own header).
  - Existing archived plans (phase-0-validate-evaluators.md, bone-plan-v3-amendment.md) must remain enforced and passing.
  - Failing test first, then the fix (AGENTS.md bugfix convention) — the fast gate (lint.sh on the repo + pytest) stays green throughout; the red lives in the harness only.

## Tasks

<!-- One atomic commit each. Record deviations inline as they happen. -->

1. [x] lint_test.sh: in section 2, (a) add case — non-plan doc, no Tasks/no Verify (e.g. `# Handoff` + prose + a `## 2 · Dispositions` heading) → `expect 0 "non-plan doc may archive — provenance docs exempt"`; (b) amend the existing `"no Verify section at all"` fixture to carry a `## Tasks` section so it stays a real plan and keeps `expect 1`. Run `sh adapters/lint_test.sh`: exactly the new case reports BAD (red) against unpatched lint.sh, all others ok — paste output. Commit. (ca12362)
2. [x] lint.sh: apply the predicate per Context sketch. `sh adapters/lint_test.sh` → all ok, 0 failing (new case flipped green; every prior case unchanged). Paste output. Commit. (3d6639e)
3. [x] `git mv upgrade-handoff-2026-07.md plans/archive/`; append the DECISIONS.md divergence row (success criterion 3); regenerate STATE.md — blocker gone, v3 closeout's archival mandate now fully met, Next action → Phase 1 human gate. One commit (this is the residual v3-closeout step landing through the now-correct gate). (fc169ab)
   - Deviation: task-3's STATE regen named this plan's own closeout as Next action, keeping it In flight — "Next action → Phase 1 gate" beside a live In-flight entry would have contradicted itself; the closeout regen (same session) lands the literal end-state.

## Verify — the gate: cannot close while any row lacks evidence

| Check | How | Evidence |
|---|---|---|
| Fast gate | `sh adapters/lint.sh && .venv/bin/python -m pytest evals/ -q` | 2026-07-05 post-task-3: `marrow-lint: ok`, `18 passed in 3.45s`; also run by pre-commit at ca12362, 3d6639e, fc169ab |
| Harness discriminates | Task 1 output: new case BAD against unpatched lint.sh; task 2 output: same case ok, `0 failing` | task 1: `BAD non-plan doc may archive — provenance docs exempt — want exit 0, got 1` = the sole red, `lint-test: 26 ok, 1 failing`; task 2: same case `ok`, `lint-test: 27 ok, 0 failing` |
| Gate still bites | In task 2's green run, the Tasks-without-Verify and blank-Evidence cases still `expect 1` and pass as such | task 2 green run: `ok Tasks but no Verify section`, `ok blank Evidence cell, trailing pipe`, `ok escaped pipe inside a cell; Evidence still blank`, `ok blank Evidence cell in a nested archive subdirectory` — all expect-1 |
| Real-world proof | Pre-commit accepts task 3's archive commit; `ls plans/archive/` lists the handoff | fc169ab landed through the hook (`marrow-lint: ok` with handoff in plans/archive/); `ls plans/archive/` → bone-plan-v3-amendment.md, phase-0-validate-evaluators.md, upgrade-handoff-2026-07.md |

## Budget

Stop if: the predicate misclassifies any existing archived plan (either existing plan skipped, or a green one failing), or the edit set grows beyond lint.sh rule 2 + lint_test.sh section 2 + the task-3 move/doc files — write a STATE.md blocker and ask.

## Closeout

Run CLOSEOUT.md. Distilled line(s) destined for DECISIONS.md:

- (task 3's divergence row is the distillation: rule 2 scoped to plan-shaped files — Verify-or-Tasks present — non-plan docs archive freely; approved divergence from vendored v0.2.0, candidate upstream diff for marrow)
