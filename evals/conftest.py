# Fixture micro-repos contain their own test files (run by the exit_code
# evaluator inside copies) — the outer suite must never collect them.
collect_ignore_glob = ["fixtures/*"]
