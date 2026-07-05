# Plan: phase-0-validate-evaluators

<!-- marrow v0 — written for an executor with NO other context: fresh session, this file + AGENTS.md only.
     Trivial tasks don't get plans. Risky-novel work fills Spec before Tasks. -->

**Intent:** Prove bone's gates before they gate anything: ship `evals/` — four deterministic evaluators, five known-good/known-bad fixture micro-repos, versioned YAML case datasets — with discrimination tests green under pytest and wired as this repo's pre-commit check. bone-plan.md Phase 0.
**Class:** risky-novel

## Success criteria (must be TRUE at close)

1. Every evaluator has ≥1 failing case it catches and ≥1 passing case it clears, across ≥2 fixtures each — enforced *in code* by a meta-test, not just observed.
2. The fresh-verify discrimination fixture exists: a planted defect the executor plausibly self-approves (smoke passes, Evidence cells filled) that deterministic re-run of the done-check catches.
3. `git commit` in this repo runs marrow-lint + the discrimination suite and blocks on red.

## Spec (risky-novel only — delete otherwise)

- Unknowns to resolve first: pytest not installed (PEP-668 blocks bare pip) → repo-local `.venv`, versions recorded below; token proxy → `ceil(utf8_bytes/4)`, deterministic and model-agnostic, documented in the docstring; diffing fixtures that have no `.git` → `git diff --no-index --numstat` (exit 1 there means "trees differ" — data, not error).
- Approach chosen + alternatives rejected: four evaluators = exactly the four signal classes Phase 0's anti-scope names (exit codes, diff stats, token counts, file existence) — nothing else qualifies in v0. Rejected: pydantic-evals as runtime dep (datasets keep its case *shape* — name/inputs/expected_output/metadata — so it can enter later through the addition gate; the dep itself buys nothing deterministic now); tiktoken (model-coupled dependency for a budget proxy); per-fixture git repos (churn and nested-repo hazards; --no-index needs none).
- Failure modes / threats designed against: evaluator overfits its fixture (risk register: ≥2 fixtures per evaluator, and both catch *and* clear appear on ≥2 for all four); outer pytest collecting fixture test files (`evals/conftest.py` collect_ignore_glob); inner pytest polluting fixtures (harness copies fixture to tmp before running); executor self-approval collusion surface (F2 bakes it in: green smoke + filled Evidence + claimed-but-absent artifact + failing done-check).
- Rollback if it ships broken: `git revert` the phase commits; `evals/` is self-contained, nothing references it yet.

## Context

- Files / entry points: `evals/evaluators.py`, `evals/fixtures/`, `evals/datasets/`, `evals/test_discrimination.py` (the shipped "discrimination tests runnable via pytest"), `evals/conftest.py` (its plumbing), `.git/hooks/pre-commit`. The two test-side files sit beyond the inventory's three `evals/` entries — they *are* the Ships line ("discrimination tests"); flagged here for human veto.
- Binding constraints (from AGENTS.md / bone-plan.md): deterministic signals only — no LLM-as-judge, no network at eval time; local-first (JSONL + git + pytest); inventory is a ceiling; every component closes/stops/shrinks a loop (evaluators are what "closed" means); commit every green step.
- Deviation, recorded: marrow's plan-in-fresh-context/execute-in-another split is superseded by the bone brief's one-phase-per-session protocol — planned and executed in this session under the human's instruction to continue.

## Evaluators × fixtures — the discrimination matrix

| Evaluator | Catches (expected FAIL) | Clears (expected PASS) |
|---|---|---|
| exit_code | F1/bad pytest, F2/bad done-check | F1/good pytest, F2/good done-check, F2/bad smoke (why self-approval was plausible) |
| diff_stats | F3 base→bad sprawl, F5 good→bad-bloated churn | F3 base→good focused, F1 good→bad one-liner |
| token_count | F4/bad bloated rules, F5/bad-bloated ledger | F4/good rules, F5/good ledger |
| file_exists | F2/bad claimed evidence absent, F5/bad-missing-ledger | F2/good artifacts present, F5/good state complete |

Fixtures: F1 `pytest-exit` (passing vs failing suite) · F2 `fresh-verify-defect` (Δ1: slugify happy-path defect; smoke green both states; plan Verify Evidence self-filled; `evidence/run.txt` only real in good) · F3 `diff-budget` (base + focused vs sprawling change) · F4 `token-budget` (rules file under vs over cap) · F5 `bone-state` (`.bone/` ledger+telemetry: good, bad-missing-ledger, bad-bloated-ledger). 17 cases total.

## Tasks

<!-- One atomic commit each. Record deviations inline as they happen. -->

1. [x] `evals/evaluators.py` (stdlib-only: EvalResult dataclass + exit_code, diff_stats, token_count, file_exists) + `evals/conftest.py`. Env: `python3 -m venv .venv && .venv/bin/pip install pytest pyyaml`; resolved: pytest 9.1.1, PyYAML 6.0.3 (PyPI).
2. [x] `evals/fixtures/` — F1–F5 exactly as the matrix specifies.
3. [x] `evals/datasets/*.yaml` (4 files, 17 cases, pydantic-evals case shape) + `evals/test_discrimination.py` (YAML-driven runner + `test_acceptance_criterion` meta-test). Suite green.
4. [x] Wire `.git/hooks/pre-commit` (marrow-lint + suite); fill AGENTS.md Commands/Verification/Environment rows. The commit itself demonstrates the hook.
5. [x] Closeout per CLOSEOUT.md — archive this plan, regenerate STATE.md, ≤3 DECISIONS.md lines.

## Verify — the gate: cannot close while any row lacks evidence

| Check | How | Evidence |
|---|---|---|
| Fast gate | `sh adapters/lint.sh && .venv/bin/python -m pytest evals/ -q` | "marrow-lint: ok" + "18 passed in 0.74s" — hook output on commit b7055a9, re-run green at every commit since |
| Discrimination matrix | suite `-v` output: all 17 cases behave per matrix; meta-test enforces criterion | pytest -v: 17 test_discrimination case ids all PASSED + test_acceptance_criterion PASSED (18 total); sabotaging exit_code to always-pass reddened exactly its 2 catch cases (2 failed, 16 passed), restore → 18 passed in 0.64s |
| Fresh-verify defect | on F2/bad: smoke exits 0 while done-check exits ≠0 and claimed artifact absent | cases smoke-clears-on-bad-tree (exit 0, cleared), done-check-bad-caught-despite-filled-evidence (inner pytest exit 1, caught), claimed-evidence-absent-caught (evidence/run.txt missing, caught) — all PASSED |
| Pre-commit wired | a real commit shows lint + suite running in hook output | b7055a9 landed through the hook (lint + 18 passed printed pre-commit); sabotaged commit "should never land" was blocked, hook exit 1, HEAD unmoved at b7055a9 |

## Budget

Stop if: 3 failed attempts on the same discrimination case; or any evaluator turns out to need network/LLM to discriminate (anti-scope trip); or evals/ needs files beyond the two flagged test-side additions.
Tripped → record it here, add a STATE.md blocker, ask before continuing.

## Closeout

Run CLOSEOUT.md. Distilled line(s) destined for DECISIONS.md:

- Vendor marrow v0.2.0 (cd04dd8) incl. adapters/; bone runs marrow's loop on itself.
- v0 evaluators = 4 deterministic signals, fail-closed; token proxy ceil(utf8_bytes/4); no LLM-judge.
- Evaluator work must prove it can fail: sabotage→red→restore→green is the behavior proof.
