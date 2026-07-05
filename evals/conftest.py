# Fixture micro-repos contain their own test files (run by the exit_code
# evaluator inside copies) — the outer suite must never collect them.
import sys
from pathlib import Path

collect_ignore_glob = ["fixtures/*"]

# Make `import evaluators` work under any pytest import mode.
sys.path.insert(0, str(Path(__file__).resolve().parent))
