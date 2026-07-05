# bone

<!-- marrow v0 -->
bone is the load-bearing layer around marrow: it runs marrow-conventioned repos through supervised, evaluator-validated loops (`bone run | bench | audit | weight`) and keeps itself small by remodeling — deletion and eval-gated addition in equilibrium. For agents and their human supervisors. What must never break: the one-way dependency — bone reads marrow's files, writes only under `.bone/` in target repos; delete bone, keep marrow. Master plan: bone-plan.md; its agent brief and anti-scope lines are binding here.

Agent conventions for this repo. STATE.md holds current focus; DECISIONS.md holds decision provenance; plans/ holds in-flight work, plans/archive/ closed work. This file states the current binding rules — if it disagrees with a newer DECISIONS.md line, this file is stale: fix it.

## Session

- Start: read this file, then STATE.md; resume its Next action unless told otherwise.
- Context diet: planning adds DECISIONS.md; executing adds the one plan. plans/archive/ is history — dig only on purpose.
- Blocked, or scope has doubled? Write a STATE.md blocker and ask.
- Parallel work: one plan per worktree; STATE.md In flight lists them all. Closeouts land serially; DECISIONS.md append conflicts resolve as keep-both.

## The loop

classify → plan → execute → verify → distill (CLOSEOUT.md). Ceremony scales by class, never by adding commands.

- `trivial` — edit + verify inline; no plan; evidence goes in the commit message.
- `multi-file` — copy plans/_TEMPLATE.md → plans/<slug>.md and list it in STATE.md In flight. Plan in a fresh context; execute in another. The plan is the entire handoff — commit it before executing.
- `risky-novel` — as multi-file, plus fill Spec before Tasks. Qualifies: new external surface (API, schema, dependency), irreversible data change, security-sensitive, or nothing in the repo to pattern-match against.
- Reclassify upward the moment a task outgrows its class: a `trivial` that touches a second file or fails verification once is `multi-file` — stop and write the plan. A `multi-file` that turns out `risky-novel` mid-execution: stop before the next task, revert uncommitted work, fill Spec retroactively — or abandon per CLOSEOUT and replan.
- Too big for one plan: split into independently verifiable plans; sequence them in STATE.md Next action.

## Commands

| Action | Command |
|---|---|
| Install | `python3 -m venv .venv && .venv/bin/pip install pytest pyyaml` |
| Lint (marrow invariants) | `sh adapters/lint.sh` |
| Discrimination suite | `.venv/bin/python -m pytest evals/ -q` |

## Verification

What constitutes **proof** that a change works. Claiming "done" requires running these and showing the output.

- Fast gate (every change): `sh adapters/lint.sh && .venv/bin/python -m pytest evals/ -q`
- Behavior proof (evaluator or fixture work): green is not enough — show the suite can fail. Sabotage the changed verdict path, observe exactly its catch cases go red, restore, re-run green; paste both outputs. An evaluator that never discriminated proves nothing.
- Evidence lands in the plan's Verify table — pasted output or a screenshot for UI — secrets redacted. A test written for this change proves it by failing before and passing after; a test that never failed proves nothing.

## Environment

Quirks that cost sessions to rediscover. Update the moment you hit one.

- Ubuntu PEP-668 blocks bare `pip install` — use the repo-local `.venv` (Install row); system python3 has no pytest.
- Git hooks are not cloned. Re-wire after a fresh clone: `printf '#!/bin/sh\nset -eu\nsh adapters/lint.sh\n.venv/bin/python -m pytest evals/ -q\n' > .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`

## Conventions

- Style: evals/ runtime code is stdlib-only Python (pytest+pyyaml live in the test harness, never in evaluators.py); shell stays POSIX sh; fixtures stay minimal — one defect per bad state.
- Commits: one atomic commit per task, imperative mood. Docs (STATE.md, DECISIONS.md, plans/) are committed like code.
- Comments: only for constraints the code cannot express.
- Bugfix: failing test first, then the fix.
- Debugging: reproduce → hypothesize → instrument → fix. Three failed fixes on one symptom → stop and write a plan.
- Dependencies: verify a new one exists in its registry — exact name, current version — before adding it; invented package names are an attack surface.
- History lives in git; docs describe the present. No document restates another — derive, don't copy.
- Vendor what you adopt: no third-party skill packs at runtime — copy in, pin, review once.

## Boundaries

What agents must not do here.

- Never push without being asked.
- `marrow/` (if present) is a read-only reference clone pinned at v0.2.0 — never edit, never commit; vendoring changes are copy-in diffs approved by the human.
- bone-plan.md anti-scope lines are hard constraints; phase boundaries are human gates — never start the next phase in the same session.
- Deterministic evaluators only in v0 — no LLM-as-judge anywhere in evals/.
