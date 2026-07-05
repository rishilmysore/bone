# Decisions

<!-- marrow v0 — append-only; newest at the bottom; one line each. Provenance lives here; the
     current rule each line implies is folded into AGENTS.md at closeout. Reversals are
     appended, never edited in. If the "why" needs a paragraph, it needed a plan — link it. -->

| Date | Decision | Why / evidence |
|---|---|---|
| 2026-07-04 | Vendor marrow v0.2.0 (cd04dd8) incl. adapters/; bone's own repo runs marrow's loop on itself | human-pinned clone; diff -r clean; lint_test 26/26 |
| 2026-07-04 | v0 evaluators = 4 deterministic signals (exit_code, diff_stats, token_count, file_exists), fail-closed; token proxy ceil(utf8_bytes/4); no LLM-judge per anti-scope | plans/archive/phase-0-validate-evaluators.md |
| 2026-07-04 | Evaluator/fixture work must prove it can fail: sabotage→red→restore→green is the required behavior proof | sabotage run: exactly the 2 exit_code catch cases red (2 failed, 16 passed); hook blocked the red commit |
