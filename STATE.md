# State

<!-- marrow v0 — regenerated at every closeout and whenever it stops being true; never appended.
     Hard cap: 25 lines; changing the cap is a decision — append the DECISIONS.md row first. Durable facts belong in DECISIONS.md or AGENTS.md, not here. -->

**Focus:** bone-plan v3 amendment landed and closed (2026-07-05); one residual closeout step — archiving the handoff — waits on the staged lint-scope fix
**Next action:** fresh session executes plans/lint-rule2-plans-only.md (scopes lint rule 2 to plan-shaped files, then archives upgrade-handoff-2026-07.md per the v3 mandate); after its closeout, a fresh session opens Phase 1 (bench format + baselines) from bone-plan.md P1 spec + Δ v3 item 1 — ≥3-seed baselines want the human's real test repos (brief item 7), public fixtures until then. Phase boundary is a human gate.

## In flight

- plans/lint-rule2-plans-only.md — exempt non-plan docs from the archive evidence gate; unblocks handoff archival (planned, not yet executed)

## Blockers

- none — the 2026-07-05 handoff-archival blocker resolved by human disposition: scope lint.sh rule 2 to real plans (see the staged plan)

## Recently closed (last 3 — older history: git log + plans/archive/)

- 2026-07-05 bone-plan-v3-amendment (multi-file) — folded 10 handoff dispositions into P1/P2/P3/P5 specs as Δ v3 riders; DECISIONS.md carries 7 provenance rows; handoff archival deferred to the lint-scope plan
- 2026-07-05 novelty-rewording (trivial, handoff Session A) — GRASP repositioned per §1.1, ACE + IFScale anchors added to bone-plan.md prior-art (cb2ee8d)
- 2026-07-04 phase-0-validate-evaluators — 4 evaluators × 5 fixtures, 17 cases + acceptance meta-test green; pre-commit gates lint+suite and provably blocks red
