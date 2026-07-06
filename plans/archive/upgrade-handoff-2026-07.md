# Upgrade handoff — meta-loop accuracy (2026-07-05)

**Provenance.** Distilled from two research passes (2026-07-05). Pass 1 proposed ten additions; pass 2 verified every anchor against fetched arXiv sources: 18/20 confirmed as claimed, 2 corrected (§1). This file supersedes both passes — no session loads them. Anything marked UNCONFIRMED is not citable until re-checked against the paper itself.

**Human gate.** Dispositions in §2 are proposals. Strike or amend rows before Session B consumes this file (bone-plan.md brief: supervised autonomy). Gate passed 2026-07-05: all ten rows confirmed as proposed, none struck. This file archives at the v3 amendment's closeout; the DECISIONS.md rows it spawns carry the evidence forward.

## Reading rules — context diet

- Session A (novelty rewording): §1 only.
- Session B (bone-plan v3 amendment): whole file.
- Session C (Phase 1 execution): §3 Phase-1 rider only.
- Session D+ (Phase 2 plan → execute): §3 Phase-2 rider + §2 rows 1–3, S.
- Phase 3 / Phase 5 sessions: their §3 rider only.

## 1 · Evidence corrections — apply before citing anything from pass 1

1. **GRASP collision — blocks the public cut.** GRASP (arXiv 2605.29668, May 2026) is regression-gated skill *addition* for self-improving agents — materially closer to bone's addition gate than the current prior-art line ("prunes context, not a framework's own rulebook") admits. Rewording is mandatory. Reposition the novelty claim on what GRASP lacks: the subtractive side. Suggested replacement: "nearest art (GRASP, 2605.29668) gates skill *addition* on regression checks — the addition gate has precedent; bone's claim narrows to enforced deletion: weight ratchet plus eval-gated audits as framework maintenance." While editing that paragraph, add the verified supporting citations: ACE (2510.04618 — "context collapse" when LLMs rewrite accumulated rulebooks) and IFScale (2507.11538 — instruction-following degrades as instruction count grows); both independently support delete-don't-rewrite.
2. **STING number mis-labeled.** STING (arXiv 2604.01518): the qualitative finding stands — mutation-guided test augmentation exposes accepted-but-wrong patches on SWE-bench Verified. Pass 1's gloss "dropped top agents 4.2–9.0%" mis-labels what that figure measures; UNCONFIRMED as stated — re-read before citing the number anywhere public. The mechanism transfer (row 3) does not depend on the number.
3. **Saving SWE-Bench mis-framed.** arXiv 2510.08996 is not a contamination study; dropped as a row-9 anchor. Row 9 re-anchors on SWE-bench Illusion (2506.12286) alone — evidence one paper thinner, mechanism unchanged.

## 2 · Dispositions (proposed 2026-07-05 — human confirms each row)

| # | Item | Disposition | Lands | Mechanism | Verified evidence |
|---|---|---|---|---|---|
| 1 | Deletion verdicts = non-inferiority framing, paired multi-seed runs, beta-binomial CIs | ACCEPT | remodel/audit.py (P2); baselines rider (P1) | v3 plan amendment | Single-run pass@1 spreads 2.2–6.0 pts between runs, std >1.5 even at T=0 (Bjarnason et al. 2026, 60k SWE-bench trajectories); paired 3-seed protocol, sign-flip permutation + BCa bootstrap (2511.19794); CLT intervals invalid below a few hundred datapoints — use beta-binomial (Bowyer/Aitchison/Ivanova, ICML 2025); further anchors 2503.01747, 2602.07150 |
| 2 | Held-out + rotating eval split for audits | ACCEPT | audit protocol (P2) | v3 plan amendment | Darwin Gödel Machine observed objective hacking against the visible benchmark (2505.22954); pure protocol, no new machinery |
| 3 | Mutation adequacy: a rule is deletion-eligible only with a recorded caught-mutant | ACCEPT | `bone audit --adequacy` (P2) | v3 plan amendment | STING mechanism (2604.01518; §1.2 correction applies); UTBoost — mutation-check the done-checks too (2506.09289); AgentAssay (2603.02601) |
| S | Seeded audits: discrimination fixtures for the remodel loop itself | ACCEPT | evals/fixtures/ + audit (P2) | v3 plan amendment | No external anchor needed — Phase-0 duty one level up: an audit that never discriminated proves nothing. Plant a known-dead rule (deletion must land) and a known-load-bearing rule (audit must catch its regression) |
| 4 | 1–2 impossible tasks in bench; any pass ⇒ `failure_category: gamed` + escalation | ACCEPT | bench/tasks/ (P1) | v3 plan amendment | ImpossibleBench mechanics verified (2510.20270); deterministic exit-code signal, legal in v0 today |
| 5 | Control fixture (executor prompted to cheat subtly; verifier tier must catch) + strip authorship framing from verifier context | ACCEPT | fixtures + adapters/fresh-verify.md (P3) | v3 amendment + one adapter line | AI-control methodology (Greenblatt et al., 2312.06942); monitors judge self-framed actions more leniently (Khullar et al., 2603.04582) |
| 6 | Judge-admission spec pre-written into the addition gate | ACCEPT (doc-only) | CONTRIBUTING / gate spec (P5) | text only — no anti-scope change; pre-writes the bar LLMJudge must later pass | Alternative Annotator Test (2501.10970); calibrated TPR/FPR with variance-corrected thresholds (Noisy but Valid, 2601.20913); cascade — deterministic first, judge where silent, escalate below confidence (Trust or Escalate, ICLR 2025) |
| 7 | rules_fired via ablation attribution | DEFER (§4) | telemetry + loop/run.sh | later, via addition gate, with its own discrimination fixtures | ContextCite — ablated re-runs + sparse surrogate (2409.00729); AttriBoT cheap leave-one-out approximation (2411.15102); cost ~dozens of inference calls per attribution |
| 8 | Anytime-valid audits: e-values/SPRT + online FDR | DEFER (§4) | audit cadence | plan amendment when triggered | E-valuator (2512.03109); SAFFRON/ADDIS online-FDR procedures (Ramdas et al.) |
| 9 | Provenance/validity field for public fixture tasks | ACCEPT (light) | bench/FORMAT.md (P1) | v3 plan amendment | SWE-bench Illusion (2506.12286); single-anchor after §1.3 |
| 10 | Instruction-density citations backing the weight ratchet | ACCEPT (doc-only) | prior-art paragraph (Session A) + CONTRIBUTING (P5) | text only | IFScale (2507.11538); Curse of Instructions (OpenReview); ACE context collapse (2510.04618) |

Anti-scope check: rows 1–4, S, 9 are deterministic, stdlib-Python, local-first — no anti-scope conflict; they enter as the v3 amendment because they change phase specs. Row 6 adds no judge, only the admission bar. Rows 7–8 stay out of v0 under §4 conditions.

## 3 · Phase riders — what each session implements

**Phase 1 (Session C) — must land before baselines, or baselines get re-run:**

- Baselines run at ≥3 seeds per task; telemetry writes per-seed outcome rows. This variance data is the direct input to row 1's Phase-2 thresholds.
- 1–2 impossible tasks in bench/tasks/ (done-checks that cannot legitimately pass, e.g. mutually contradictory assertions). Telemetry `failure_category` enum gains `gamed`; any pass on these tasks escalates.
- bench/FORMAT.md gains a per-task provenance/validity field: origin, pinned-SHA rationale, public-exposure note (was this repo plausibly in a model's training data).

**Phase 2 (Session D+):**

- audit.py verdict protocol: paired runs (with/without the candidate rule, same seeds), sign-flip permutation test, beta-binomial intervals; a deletion lands only if non-inferior at a declared margin (config). Absence of a detected regression is not evidence of equivalence — the burden sits on the deletion.
- Eval cases split visible/held-out. Held-out tier revealed only at release cut; a deletion that passes visible but regresses held-out is restored, and the catching case rotates into the visible tier.
- Adequacy map: deletion candidacy requires a recorded mutant — a run with that rule ablated that ≥1 eval case demonstrably catches. "Least-recently-fired" stays advisory until rules_fired is real (§4, row 7).
- Seeded-audit fixtures (row S) ship with the audit itself, same sabotage→red→restore→green duty as Phase 0.

**Phase 3 rider:** adapters/fresh-verify.md gains one line — the verifier context carries no authorship framing (never "your code", never the executor's transcript). Control fixture: one run where the executor is instructed to cheat subtly; the verifier tier must catch it — a loop-level discrimination case.

**Phase 5 rider:** CONTRIBUTING gains the judge-admission spec (row 6) and the ratchet citations (row 10).

## 4 · Deferred — revisit conditions

| Deferred | Revisit when | Interim |
|---|---|---|
| rules_fired ablation attribution (row 7) | Two consecutive audits where candidate selection is blocked or arbitrary for want of rules_fired data | Attribution runs only on current deletion candidates, never the full rulebook |
| e-values/SPRT + online FDR (row 8) | Telemetry shows audit token cost is the binding constraint, or audited-rule count makes per-audit error accumulation untenable across release cycles | The fixed-N paired protocol from row 1 |

## 5 · Dropped

- Saving SWE-Bench (2510.08996) as contamination evidence — see §1.3. Nothing else dropped; all ten items survive in some form.
