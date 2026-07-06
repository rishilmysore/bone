# State

<!-- marrow v0 — regenerated at every closeout and whenever it stops being true; never appended.
     Hard cap: 25 lines; changing the cap is a decision — append the DECISIONS.md row first. Durable facts belong in DECISIONS.md or AGENTS.md, not here. -->

**Focus:** bone-plan v3 amendment specs landed (2026-07-05) — P1/P2/P3/P5 carry the Δ v3 riders, DECISIONS.md has 7 provenance rows, amendment plan archived. Closeout is complete except the handoff archival, which is blocked.
**Next action:** human resolves the blocker below, then finish the handoff archival; afterward a fresh session opens Phase 1 (bench format + baselines) reading bone-plan.md P1 spec + Δ v3 item 1 (≥3-seed baselines need the human's real test repos, brief item 7 — public fixtures until then). Phase boundary is a human gate.

## In flight

- none

## Blockers

- **Handoff archival vs. lint invariant.** The amendment plan + upgrade-handoff-2026-07.md's own header mandate archiving the handoff to plans/archive/ at this closeout. But adapters/lint.sh rule 2 requires every plans/archive/*.md to be an evidence-complete plan (Verify section + Evidence column + rows); the handoff is a research-provenance doc with no Verify table, so the move fails the pre-commit gate. The plan's Budget bounds the edit set to the archive move alone — the two honest fixes (retrofit a truthful Verify section onto the handoff, or scope lint.sh rule 2 to real plans + update lint_test.sh) both exceed budget and one edits a vendored adapter. Human call needed. Handoff currently held at repo root, unarchived. Evidence it carries is already safe in DECISIONS.md (7 rows) + git.

## Recently closed (last 3 — older history: git log + plans/archive/)

- 2026-07-05 bone-plan-v3-amendment (multi-file) — folded 10 handoff dispositions into P1/P2/P3/P5 specs as Δ v3 riders; DECISIONS.md carries 7 provenance rows; plan archived; handoff archival blocked (see Blockers)
- 2026-07-05 novelty-rewording (trivial, handoff Session A) — GRASP repositioned per §1.1, ACE + IFScale anchors added to bone-plan.md prior-art (cb2ee8d)
- 2026-07-04 phase-0-validate-evaluators — 4 evaluators × 5 fixtures, 17 cases + acceptance meta-test green; pre-commit gates lint+suite and provably blocks red
