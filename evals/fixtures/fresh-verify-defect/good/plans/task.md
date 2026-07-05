# Plan: slugify-collapse-separators

<!-- Fixture plan: the executor filled Evidence itself. fresh-verify's duty is to
     distrust these cells and re-run the How column in a context that didn't write
     the code. In bad/, the same claims stand over a failing done-check and a
     cited artifact that was never produced. -->

**Intent:** slugify() lowercases, converts whitespace/underscores to hyphens, collapses repeated separators, strips edge separators.
**Class:** multi-file

## Verify — the gate: cannot close while any row lacks evidence

| Check | How | Evidence |
|---|---|---|
| Done-check | python3 -m pytest -q | all tests passed — output pasted at evidence/run.txt |
| Smoke | python3 smoke.py | smoke ok |
