# bone — loop engineering around marrow

*Marrow lives inside bone. bone is the load-bearing layer that runs marrow-conventioned projects through supervised, evaluator-validated loops — and keeps itself small by remodeling: deletion and eval-gated addition in equilibrium, driven by measured load.*

**Status:** plan v2. Amends the marrow-loop plan: renamed to bone, re-baselined at marrow **v0.2.0** (tag published 2026-07-04, commit `cd04dd8`).

## Agent brief — read before Phase 0

You are building bone in this repo, one phase per session.

1. marrow v0.2.0 should already be vendored here (`AGENTS.md`, `plans/`, `adapters/` — including `adapters/fresh-verify.md`). Read them before anything else; this plan assumes them throughout. If they're missing, stop and ask — vendoring is a human-approved step.
2. Binding constraints, in order: supervised autonomy (human gate at every phase boundary and tripwire); local-first (JSONL + git + pytest, nothing hosted); minimalism (the file inventory is a ceiling, not a floor).
3. Every component must close a loop, stop a loop, or shrink what crosses one. If it does none of those, do not build it.
4. A phase is done only when its "Accepts when" criterion demonstrably passes. Stop there and wait for human review. Never start the next phase in the same session.
5. Commit at every green step. Git is the only persistence; if it isn't committed, it didn't happen.
6. Anti-scope lines are hard constraints. When blocked or uncertain, write an escalation — tried / why-failed / hypothesis / one question — instead of improvising.
7. Phase 1's real-repo bench tasks wait on repos the human supplies; use the public fixtures until then.

---

## Why "bone"

The anatomy supplies the architecture. Bone surrounds marrow and bears the load; marrow stays soft and essential inside. Bone tissue stays healthy through *remodeling* — resorption removes material that measured load no longer justifies, deposition adds only where load demands it (Wolff's law). That is the subtractive meta-loop, named by biology. The loop skeleton's five joints extend the same metaphor: joints are where bones articulate.

The metaphor lives in the README. The interface stays boring: `bone run`, `bone bench`, `bone audit`.

**Positioning.** bone is a separate repo, vendored the same way marrow is (copy-in diffs, no package dependency). The dependency is strictly one-way: bone reads marrow's files; marrow never knows bone exists and remains fully usable standalone. Delete bone, keep marrow. bone v0 targets marrow only — generalizing to other convention layers is explicitly deferred.

---

## Δ from the prior plan — deletions first

1. **Deleted: the fresh-context verifier build.** marrow v0.2.0 ships `adapters/fresh-verify.md` — a finished plan's Verify table re-run in a fresh context that didn't write the code. bone now *wires* it (phase-exit verification tier, verifier model from `bone.toml`) instead of building it, and adds one discrimination fixture: a planted defect the executor plausibly self-approves, which fresh-verify must catch. Scope −1 day.
2. **Phase 0 re-anchored to marrow's own epistemology.** v0.2.0's red→green duty — *a test that never failed proves nothing* — generalizes one level up: *an evaluator that never discriminated proves nothing.* Phase 0 cites the duty directly; the eval harness reads as marrow philosophy extended, not an import.
3. **Baselines re-anchored at v0.2.0.** Framework weight is measured against the five new rule-units (dependency-registry duty, red→green sentence, security failure-modes prompt, UI rendered-evidence line, fresh-verify adapter). New duties enter **protected** — exempt from deletion candidacy — with an expiry (default: 3 release cycles or 25 telemetered runs, whichever first), after which they compete like every other rule.
4. **Addition gate reframed as formalization, not invention.** v0.2.0's upgrade model ("each arrives only inside an upgrade diff you choose to apply," per-item remediation, "delete it if unused") is the manual ancestor of the addition gate. bone attaches eval evidence to a ceremony marrow users already perform.
5. **Renamed throughout.** marrow-loop → bone. State dir in target repos: `.bone/`. Config: `bone.toml`. Done-check vocabulary in bench tasks may now reference v0.2.0 duty types by name (registry verification, red→green evidence, rendered-artifact evidence).

No phases added, none reordered.

---

## Architecture

**Contracts.** bone reads `AGENTS.md`, `plans/`, and `adapters/` in a target repo. bone writes only under `.bone/` in target repos and inside its own repo. The summary artifacts it produces (escalation reports, audit diffs) are the only things intended to cross back to a human.

**Rule addressing without touching marrow.** Every deletable unit gets a derived ID: `module-slug/heading-slug@hash6` (first 6 chars of the heading-path content hash). Zero marrow changes required; if hashing proves brittle in practice, optional inert anchor comments arrive later as a normal marrow upgrade diff.

**File inventory (complete — the ceiling, not the floor):**

```
bone/
  bone.toml            # roles→models, budgets, caps, parallel flag (off)
  bin/bone             # single entry: run | bench | audit | weight
  loop/run.sh          # plan→execute→verify cycle via headless invocations
  loop/spin.py         # diff-of-diffs detector
  loop/escalate.md     # tried / why-failed / hypothesis / one-question template
  loop/tripwires.json  # PreToolUse denylist → human gate
  evals/evaluators.py  # deterministic wrappers: exit codes, diff stats, tokens
  evals/fixtures/      # known-good / known-bad micro-repos
  evals/datasets/      # Pydantic Evals cases, YAML, versioned in git
  bench/FORMAT.md      # task spec: goal, repo@sha, done-check, budget
  bench/tasks/         # the user's real-repo tasks + public fixture tasks
  remodel/audit.py     # weight, candidate selection, deletion protocol
```

Target-repo state: `.bone/ledger.jsonl`, `.bone/telemetry.jsonl`, `.bone/escalations/`.

**Model routing (`bone.toml`), defaults as of July 2026:**

| Role | Default | Rationale |
|---|---|---|
| planner | `claude-opus-4-8` | plan quality dominates loop outcomes |
| executor | `claude-sonnet-4-6` | mechanical work, best cost/quality |
| verifier | `claude-opus-4-8` | different model than executor resists collusion |

Roles are plain strings — swap any of them (e.g., Fable 5 as planner where available and budget allows). `bone run` verifies configured model strings against the platform at startup rather than trusting this table; current names live at https://docs.claude.com. Agent-agnosticism is the config schema, not an abstraction layer.

---

## Phases

### Phase 0 — Validate the evaluators (~2 days)

Nothing gates anything until the gates themselves are proven. Build 3–5 fixture micro-repos with known-good and known-bad states; every evaluator must catch the bad and clear the good before it may judge real work. This is v0.2.0's red→green duty applied to the meta level, and it includes the fresh-verify fixture from Δ1.

**Ships:** `evals/` complete; discrimination tests runnable via pytest locally, wired as a pre-commit check in bone's repo.
**Accepts when:** every evaluator has at least one failing case it catches and one passing case it clears, across ≥2 fixtures each.
**Anti-scope:** no LLM-as-judge in v0 — deterministic signals only (exit codes, diff stats, token counts, file existence). LLMJudge may enter later *through the addition gate* like any rule.
**Joint test:** closes the loop — evaluators are what "closed" means.

### Phase 1 — Bench format + baselines at v0.2.0 (~2 days)

A shareable, SWE-bench-lite-shaped task format for arbitrary local repos: `task.md` (goal + done-check referencing duty vocabulary) + repo pinned at a SHA + budget (tokens, iterations, wall time). Capture baselines: run today's marrow-plus-manual workflow on 5–10 tasks from the real test repos; record the telemetry schema `{task_id, role, model, tokens_in, tokens_out, iterations, wall_s, outcome, failure_category, rules_fired[]}` (`rules_fired` uses Phase-2 IDs; log empty until then). Compute the v0.2.0 **framework weight**: total tokens of all always-loaded rules.

**Ships:** `bench/FORMAT.md`, initial `bench/tasks/`, telemetry JSONL writer, baseline results committed.
**Accepts when:** a stranger (or you, next month) can re-run a bench task from its spec and reproduce the baseline within stated variance.
**Anti-scope:** no dashboard, no hosted anything. JSONL + git is the database.
**Joint test:** shrinks what crosses the loop — budgets and baselines are numbers, not vibes.

### Phase 2 — Remodel: the subtractive meta-loop (~3 days) — flagship

Rules become individually addressable units (IDs per Architecture). Candidate selection from telemetry: least-recently-fired, highest token cost, oldest-unmodified — minus protected-tagged units (Δ3). The audit: delete candidate → run full eval suite → no regression ⇒ deletion lands as a human-approved diff with a changelog entry; regression ⇒ restore and stamp "earned its place" with date and failing case. The **addition gate** is the mirror image: a new rule enters only inside an upgrade diff carrying an eval delta that demonstrates improvement. The **weight ratchet**: released weight may not exceed the previous release's weight unless an addition's eval delta explicitly justifies the exception in the changelog.

Cadence: audit on every release cut, or every N loop-runs (default 25). Human approves every diff — supervised autonomy applies to the framework, not just the code.

**Ships:** `remodel/audit.py`, `bone weight`, `bone audit`, changelog conventions.
**Accepts when:** one full remodel cycle runs against marrow v0.2.0's rule set and produces either ≥1 landed deletion or a documented all-rules-earned-keep result with evidence.
**Anti-scope:** no auto-merge; no rule *generation* or tuning (DSPy-style optimization is explicitly out — bone deletes, it does not write).
**Joint test:** this *is* the meta-loop.

### Phase 3 — Loop mechanics (~3 days)

The supervised run loop, each mechanic shipping with its Phase-0 fixture:

**Ledger.** `.bone/ledger.jsonl`, append-only `{task, attempt, action, failure, evidence_ref}`; top-K entries for the task injected into every retry. Fixture: a retry whose diff matches a ledgered dead end fails the run.
**Spin detector.** Normalize consecutive attempts' git diffs; similarity above threshold across two attempts ⇒ spin ⇒ escalate. (OpenHands' StuckDetector refined to git-diff granularity; notifies, never crashes.) Fixture: two near-identical failing attempts must trip it.
**Caps + escalation.** Default 3 attempts per task, then a fixed-format report (`loop/escalate.md`) to `.bone/escalations/` — tried, why each failed, current hypothesis, one specific question. Budget exhaustion is treated identically to a failing check: escalate, don't push through.
**Tripwires.** PreToolUse-hook denylist (force-push, migrations, deletes outside the worktree, external writes) pauses for a human. Supervised autonomy is these gates plus bounded sessions — never unattended overnight runs.
**Two-tier verification.** Per-iteration: cheap deterministic checks only. Phase-exit: marrow's `fresh-verify` adapter under the verifier model.

**Accepts when:** a full loop run on a bench task completes with every mechanic demonstrably firing on its fixture and telemetry rows written per role/model.
**Anti-scope:** no retry-strategy cleverness (backoff schedules, prompt mutation) — a retry differs only by ledger contents.
**Joint test:** stops loops (caps, spin, budgets) and closes them (checks, fresh-verify).

### Phase 4 — Codebase as checkpoint + opt-in parallelism (~2 days)

Commit-per-green-iteration (`bone: <task-id> iter <n> green`); rollback is `git reset`; resume is ledger + last green commit — the repo is the persistence layer, no agent-state database. Parallelism stays **off by default**: opt-in per `bone.toml`, worktree fan-out only for tasks a human declared independent in their bench specs (disjoint file contracts), reconciled by sequential re-verify on the integration branch.

**Accepts when:** kill a run mid-task, resume, and finish with no state outside git + `.bone/`; one two-task parallel run reconciles clean.
**Anti-scope:** no DAG solver, no inferred independence, no merge-conflict AI heroics — conflicts escalate to the human.
**Joint test:** shrinks what survives the loop to git objects.

### Phase 5 — Public hardening without ceremony (~2 days)

Stable public surface = `bone.toml` schema, bench task format, both JSONL schemas, and the rule-ID convention — semver'd; everything else is internal and may churn. `CONTRIBUTING.md` encodes the ethos: additions require an eval delta (the gate), deletions are celebrated (changelog keeps a "Removed, with evidence" section), README carries the weight badge and stays under a 2k-token budget. Public fixture tasks let strangers reproduce evals without your private repos. Governance for staying small is already built: ratchet + audit cadence + addition gate.

**Accepts when:** a person who has never spoken to you vendors bone into a marrow project and completes one supervised loop run using only the docs.
**Anti-scope:** no plugin system, no website, no Discord-driven feature intake. Feature requests arrive as eval deltas or not at all.
**Joint test:** the governance *is* the meta-loop, applied socially.

**Total: ~14 focused days**, sequenced so each phase's gates are proven before the next depends on them. Re-prioritize between phases as your test-repo results come in — the phase boundaries are the iterative feedback points you asked for.

---

## Risk register

| Risk | Mitigation built in |
|---|---|
| Evaluators overfit their fixtures | each evaluator validated on ≥2 fixtures; fixtures rotate as bench tasks graduate into them |
| Deleting a rule whose value is rare | protected tags with expiry; a rule needs eval coverage before it's deletion-eligible; restores are stamped and remembered |
| Bench staleness | tasks pinned to SHAs; re-pin on each bone release |
| Audit token cost | tiered suites — smoke (fixtures only) per audit, full (real-repo tasks) per release; cost estimated from Phase-1 telemetry before committing to cadence |
| Claude Code / model churn | all platform invocation isolated in `loop/run.sh`; model strings verified at startup against docs |
| Executor–verifier collusion | different default models per role; verifier context is read-only and fresh |
| Public pressure to grow | the addition gate is the answer, in writing, in CONTRIBUTING |

---

## What's genuinely new here (stated honestly)

Enforced-deletion governance — weight ratchet plus eval-gated audits as *framework* maintenance — has no shipped precedent found; nearest art (GRASP, May 2026) prunes context, not a framework's own rulebook, so bone's claim is the governance, positioned as a refinement where pruning research overlaps. Evaluator-validated loop mechanics (every mechanic ships with discrimination fixtures) formalizes what harness builders do ad hoc. Codebase-as-checkpoint inverts the Lang*-ecosystem assumption that agent state lives beside the app rather than inside the repo. Prior art in one line each: LangGraph/LangChain/Pydantic AI ship mechanism, not opinion; Langfuse/LangSmith version prompts, not rulebooks, and observe budgets rather than gate on them; OpenHands detects stuckness but has no subtractive governance; DSPy optimizes by adding and tuning — bone's contribution is a framework that provably shrinks; GSD/spec-kit/BMAD have conventions but no evals, no ratchet, no ledger. Marrow supplies the conventions; bone makes them load-bearing.
