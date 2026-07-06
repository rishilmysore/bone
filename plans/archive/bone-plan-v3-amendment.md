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

1. [x] Amend Phase 1 spec with the §3 Phase-1 rider (≥3 seeds + per-seed telemetry rows; 1–2 impossible tasks, `failure_category` gains `gamed`, any pass escalates; FORMAT.md provenance/validity field). State the blocking relation: rider lands before baselines, or baselines get re-run.
2. [x] Amend Phase 2 spec with the §3 Phase-2 rider (paired same-seed runs, sign-flip permutation, beta-binomial intervals, declared non-inferiority margin in config — burden on the deletion; visible/held-out split with rotate-on-catch; adequacy map — deletion candidacy requires a recorded caught-mutant, least-recently-fired stays advisory until rules_fired is real; row-S seeded-audit fixtures with the Phase-0 sabotage→red→restore→green duty).
3. [x] Amend Phase 3 spec (verifier context carries no authorship framing — one adapters/fresh-verify.md line, spec'd here, implemented in Phase 3; control fixture: executor instructed to cheat subtly, verifier tier must catch).
4. [x] Amend Phase 5 spec (CONTRIBUTING gains the row-6 judge-admission spec — doc-only, pre-writes the bar LLMJudge must later pass through the addition gate — and the row-10 ratchet citations).
5. [x] Record rows 7–8 as deferrals with their §4 revisit conditions where the plan already holds risk/deferral text (risk register or a Δ-v3 block) — visible to future sessions without becoming phase tasks.
6. [x] Mark the amendment as v3 in the doc's existing Δ convention; append DECISIONS.md provenance rows (evidence columns from handoff §2 verified-evidence cells).

## Verify — the gate: cannot close while any row lacks evidence

| Check | How | Evidence |
|---|---|---|
| Fast gate | `sh adapters/lint.sh && .venv/bin/python -m pytest evals/ -q` | `marrow-lint: ok`; `18 passed` (re-run green after each of the 6 task commits; pre-commit hook gated every one) |
| Traceability | For each §2 ACCEPT row, quote the amended bone-plan.md line landing it (map: 1,2,3,S→P2; 4,9→P1; 5→P3; 6,10→P5); rows 7–8 quoted as deferrals with revisit conditions | **Row 1** (non-inferiority/paired/CIs)→P2 L118 "paired runs with and without the candidate at the same seeds, sign-flip permutation test, beta-binomial intervals; the deletion lands … only if non-inferior at the margin declared in `bone.toml`" + P1 L95 "at ≥3 seeds per task, telemetry writing per-seed outcome rows". **Row 2** (held-out split)→P2 L118 "Eval cases split visible/held-out … a deletion that passes visible but regresses held-out is restored, and the catching case rotates into the visible tier". **Row 3** (mutation adequacy)→P2 L118 "a rule is deletion-eligible only with a recorded caught-mutant … surfaced as an adequacy map by `bone audit --adequacy`". **Row S** (seeded audits)→P2 L120 "seeded-audit fixtures ship with the audit … plant a known-dead rule … and a known-load-bearing rule … sabotage→red→restore→green". **Row 4** (impossible tasks)→P1 L95 "1–2 **impossible tasks** … the `failure_category` enum gains `gamed`, and any pass on an impossible task records it and escalates". **Row 9** (provenance field)→P1 L95 "`FORMAT.md` carries a per-task provenance/validity field — origin, pinned-SHA rationale, and a public-exposure note". **Row 5** (control fixture + strip framing)→P3 L127 "verifier context carries no authorship framing … Control fixture … the executor is instructed to cheat subtly; the verifier tier must catch it". **Row 6** (judge-admission spec)→P5 L143 "pre-writes the **judge-admission bar** … alternative-annotator test … calibrated TPR/FPR … cascade". **Row 10** (ratchet citations)→P5 L143 "instruction-density citations behind the weight ratchet … ACE and IFScale, plus Curse of Instructions" (+ Session A prior-art para, commit cb2ee8d). **Rows 7–8** deferrals→risk register L165–166, each with revisit condition ("two consecutive audits find candidate selection blocked" / "audit token cost is the binding constraint"). |
| No scope drift | Diff shows anti-scope lines unmodified (except where a rider legitimately extends its own phase's spec); command surface still `run | bench | audit | weight` | `git diff cb2ee8d..HEAD`: zero `**Anti-scope:**` constraint lines added/removed; no new dependency line; command surface line unchanged (`bin/bone … run | bench | audit | weight`); `--adequacy` appears only as a flag on `bone audit`, never as a 5th command. Edit set = bone-plan.md + DECISIONS.md + STATE.md + plan (+ handoff archive at closeout) — within budget. |
| Behavior | n/a — doc-only amendment; behavior-proof duty transfers to Phases 1–3 via the riders' fixture requirements | Stated, not skipped: no runtime behavior changed here. The riders each carry a fixture obligation discharged in-phase — P1 impossible-task escalation, P2 seeded-audit + adequacy fixtures, P3 control-fixture cheat-catch — under the standing Phase-0 sabotage→red→restore→green duty. The plan's acceptance lines now name these so a future session cannot green the phase without them. |

## Budget

Stop if: a §2 row cannot land without contradicting an anti-scope line (human call — STATE.md blocker, ask), or the edit set grows beyond bone-plan.md + DECISIONS.md + STATE.md + the handoff archive move.

## Closeout

Run CLOSEOUT.md. Archive upgrade-handoff-2026-07.md to plans/archive/ (its header mandates this at v3 closeout). Distilled line(s) destined for DECISIONS.md:

- Landed as task 6: seven provenance rows (amendment header + P1/P2/P3/P5 riders + deferrals), evidence cells carrying §2 arXiv anchors with §1 corrections (STING number UNCONFIRMED → mechanism-only; Saving SWE-Bench dropped). No further closeout rows — the amendment's whole purpose was to carry this provenance forward, so it lives in DECISIONS.md, not a one-liner summary.

### Decisions taken (the plan left these open; resolved 2026-07-05)

- **Rider integration:** native weave into each phase's spec prose with `(Δ-v3)` cross-refs + a new `Δ v3` section — matches the v2 `Δ` convention and "docs describe the present," over a bolt-on rider block that would restate the handoff.
- **Gate criteria:** each amended phase's *Accepts-when* line tightened to name its rider, so a future session cannot green the phase while skipping it (P1 ≥3-seed rows + impossible-task escalation; P2 paired protocol + seeded fixtures discriminate; P3 control-fixture cheat caught; P5 CONTRIBUTING carries the bar).
- **Deferrals home:** two risk-register rows carry rows 7–8's revisit conditions inline (the register is the standing surface future sessions consult); `Δ v3` item 5 points to them rather than restating.
- **DECISIONS granularity:** per-landing (~5 → 7 with header + deferrals), not per-§2-row (10) nor a single row; fine-grained per-disposition traceability stays in this Verify table + the archived handoff.

No deviations from the task list — all six tasks landed as written, one atomic commit each, fast gate green on every commit.
