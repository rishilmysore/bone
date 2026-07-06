# Decisions

<!-- marrow v0 — append-only; newest at the bottom; one line each. Provenance lives here; the
     current rule each line implies is folded into AGENTS.md at closeout. Reversals are
     appended, never edited in. If the "why" needs a paragraph, it needed a plan — link it. -->

| Date | Decision | Why / evidence |
|---|---|---|
| 2026-07-04 | Vendor marrow v0.2.0 (cd04dd8) incl. adapters/; bone's own repo runs marrow's loop on itself | human-pinned clone; diff -r clean; lint_test 26/26 |
| 2026-07-04 | v0 evaluators = 4 deterministic signals (exit_code, diff_stats, token_count, file_exists), fail-closed; token proxy ceil(utf8_bytes/4); no LLM-judge per anti-scope | plans/archive/phase-0-validate-evaluators.md |
| 2026-07-04 | Evaluator/fixture work must prove it can fail: sabotage→red→restore→green is the required behavior proof | sabotage run: exactly the 2 exit_code catch cases red (2 failed, 16 passed); hook blocked the red commit |
| 2026-07-05 | bone-plan v3 amendment folds handoff dispositions into phase specs (spec-only; no phase started, no anti-scope moved) | plans/archive/upgrade-handoff-2026-07.md §2 gate passed 2026-07-05, all 10 rows; §1: STING number UNCONFIRMED (mechanism-only), Saving SWE-Bench (2510.08996) dropped as anchor |
| 2026-07-05 | P1 rider: ≥3-seed baselines w/ per-seed telemetry (blocking — else re-run), 1–2 impossible tasks + `gamed` escalation, FORMAT.md provenance field | run-to-run pass@1 variance std >1.5 at T=0 (Bjarnason et al. 2026, 60k SWE-bench traj); ImpossibleBench (2510.20270); SWE-bench Illusion (2506.12286) |
| 2026-07-05 | P2 rider: paired same-seed deletion verdict (sign-flip permutation, beta-binomial CIs, non-inferiority margin in config, burden on deletion), visible/held-out split w/ rotate-on-catch, adequacy map req. caught-mutant, seeded-audit fixtures | 2511.19794; beta-binomial (Bowyer/Aitchison/Ivanova, ICML 2025); 2503.01747, 2602.07150; DGM objective hacking (2505.22954); STING mechanism (2604.01518), UTBoost (2506.09289), AgentAssay (2603.02601); row-S = Phase-0 duty, no ext. anchor |
| 2026-07-05 | P3 rider: verifier context strips authorship framing (one adapters/fresh-verify.md line) + control fixture (executor cheats, verifier must catch) | AI-control methodology (Greenblatt et al., 2312.06942); monitors judge self-framed actions more leniently (Khullar et al., 2603.04582) |
| 2026-07-05 | P5 rider (doc-only): CONTRIBUTING pre-writes judge-admission bar + ratchet citations — adds no v0 judge, only the future addition-gate bar | Alternative Annotator Test (2501.10970); Noisy but Valid (2601.20913); Trust or Escalate (ICLR 2025); IFScale (2507.11538), Curse of Instructions (OpenReview), ACE (2510.04618) |
| 2026-07-05 | Rows 7–8 deferred out of v0 (rules_fired ablation attribution; anytime-valid audits) — revisit conditions in risk register | ContextCite (2409.00729), AttriBoT (2411.15102); E-valuator (2512.03109), SAFFRON/ADDIS (Ramdas et al.) |
