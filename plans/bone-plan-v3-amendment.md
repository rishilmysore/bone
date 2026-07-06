# Plan: bone-plan-v3-amendment

<!-- marrow v0 — written for an executor with NO other context: fresh session, this file + AGENTS.md only.
     Trivial tasks don't get plans. Risky-novel work fills Spec before Tasks. -->

**Intent:** Fold the human-confirmed dispositions of upgrade-handoff-2026-07.md (the "Session B" this plan implements — read that file IN FULL, it is the content; this wrapper is only tasks + gate) into bone-plan.md as the v3 amendment, so Phases 1–5 execute against evidence-anchored specs.
**Class:** multi-file

## Success criteria (must be TRUE at close)

1. Every ACCEPT row in handoff §2 (1, 2, 3, S, 4, 5, 6, 9, 10) is traceable to an amended bone-plan.md phase-spec line; DEFER rows 7–8 appear only as revisit-conditioned deferrals (handoff §4), never as phase work.
2. bone-plan.md phase specs carry their §3 riders: P1 (seeds, impossible tasks + `gamed`, provenance field — marked blocking: lands before baselines or baselines re-run), P2 (paired-verdict protocol, held-out split, adequacy map, seeded-audit fixtures), P3 (no-authorship-framing line + control fixture), P5 (judge-admission spec + ratchet citations).
3. DECISIONS.md carries the amendment's provenance rows with the verified evidence from §2; the handoff file is archived (its header mandates archiving at this closeout).
4. Anti-scope lines survive intact — no LLM-judge in v0, no new deps, the four commands (`run | bench | audit | weight`) unchanged (`--adequacy` is a flag on `audit`, not a command).

## Context

- Files / entry points: upgrade-handoff-2026-07.md (whole file — its §"Reading rules" assigns Session B the whole file); bone-plan.md §Phases (P1 ~:93, P2 ~:102, P3 ~:113, P5 ~:135), §Risk register, §Δ; DECISIONS.md; STATE.md.
- Binding constraints (from AGENTS.md / DECISIONS.md / the handoff):
  - Handoff §2 human gate PASSED 2026-07-05, all rows as proposed — do not re-litigate dispositions.
  - Handoff §1 corrections are settled: the §1.2 STING figure is UNCONFIRMED — never cite the number, only the mechanism; Saving SWE-Bench (2510.08996) is dropped as an anchor (§1.3), row 9 anchors on SWE-bench Illusion alone.
  - Session A already landed (commit cb2ee8d): bone-plan.md's novelty paragraph is reworded and carries ACE/IFScale — do not re-edit it; row 10's remaining leg is P5/CONTRIBUTING only.
  - This amendment edits specs only. It does not begin Phase 1 — phase boundaries stay human gates.

## Tasks

<!-- One atomic commit each. Record deviations inline as they happen. -->

1. [ ] Amend Phase 1 spec with the §3 Phase-1 rider (≥3 seeds + per-seed telemetry rows; 1–2 impossible tasks, `failure_category` gains `gamed`, any pass escalates; FORMAT.md provenance/validity field). State the blocking relation: rider lands before baselines, or baselines get re-run.
2. [ ] Amend Phase 2 spec with the §3 Phase-2 rider (paired same-seed runs, sign-flip permutation, beta-binomial intervals, declared non-inferiority margin in config — burden on the deletion; visible/held-out split with rotate-on-catch; adequacy map — deletion candidacy requires a recorded caught-mutant, least-recently-fired stays advisory until rules_fired is real; row-S seeded-audit fixtures with the Phase-0 sabotage→red→restore→green duty).
3. [ ] Amend Phase 3 spec (verifier context carries no authorship framing — one adapters/fresh-verify.md line, spec'd here, implemented in Phase 3; control fixture: executor instructed to cheat subtly, verifier tier must catch).
4. [ ] Amend Phase 5 spec (CONTRIBUTING gains the row-6 judge-admission spec — doc-only, pre-writes the bar LLMJudge must later pass through the addition gate — and the row-10 ratchet citations).
5. [ ] Record rows 7–8 as deferrals with their §4 revisit conditions where the plan already holds risk/deferral text (risk register or a Δ-v3 block) — visible to future sessions without becoming phase tasks.
6. [ ] Mark the amendment as v3 in the doc's existing Δ convention; append DECISIONS.md provenance rows (evidence columns from handoff §2 verified-evidence cells).

## Verify — the gate: cannot close while any row lacks evidence

| Check | How | Evidence |
|---|---|---|
| Fast gate | `sh adapters/lint.sh && .venv/bin/python -m pytest evals/ -q` | |
| Traceability | For each §2 ACCEPT row, quote the amended bone-plan.md line landing it (map: 1,2,3,S→P2; 4,9→P1; 5→P3; 6,10→P5); rows 7–8 quoted as deferrals with revisit conditions | |
| No scope drift | Diff shows anti-scope lines unmodified (except where a rider legitimately extends its own phase's spec); command surface still `run | bench | audit | weight` | |
| Behavior | n/a — doc-only amendment; behavior-proof duty transfers to Phases 1–3 via the riders' fixture requirements (state this in the closeout, don't skip it silently) | |

## Budget

Stop if: a §2 row cannot land without contradicting an anti-scope line (human call — STATE.md blocker, ask), or the edit set grows beyond bone-plan.md + DECISIONS.md + STATE.md + the handoff archive move.

## Closeout

Run CLOSEOUT.md. Archive upgrade-handoff-2026-07.md to plans/archive/ (its header mandates this at v3 closeout). Distilled line(s) destined for DECISIONS.md:

- (drafted per task 6 from handoff §2 evidence cells; finalized here)
