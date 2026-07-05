"""Deterministic evaluators — bone's only judges in v0.

Nothing gates real work until it has proven, on evals/fixtures/, that it
catches a known-bad state and clears a known-good one. That is marrow's
red→green duty one level up: an evaluator that never discriminated
proves nothing (bone-plan.md, Phase 0).

Signals are exactly the four the Phase-0 anti-scope allows — exit codes,
diff stats, token counts, file existence. No LLM, no network, no clock.
Evaluators fail closed: if a measurement cannot be taken (timeout,
missing input, git error), the result is a fail, never a silent pass.
"""

from __future__ import annotations

import json
import math
import subprocess
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class EvalResult:
    """One verdict: which evaluator, pass/fail, and the raw measurement."""

    evaluator: str
    passed: bool
    signal: dict

    def to_json(self) -> str:
        return json.dumps(
            {"evaluator": self.evaluator, "passed": self.passed, "signal": self.signal},
            sort_keys=True,
        )


def exit_code(cmd: list[str], cwd: str | Path, expect: int = 0, timeout_s: int = 120) -> EvalResult:
    """Run cmd in cwd; pass iff its exit code equals expect. A hang is a fail."""
    signal: dict = {"cmd": list(cmd), "expect": expect}
    try:
        proc = subprocess.run(
            cmd, cwd=str(cwd), capture_output=True, text=True, timeout=timeout_s
        )
    except subprocess.TimeoutExpired:
        signal.update({"exit_code": None, "timed_out": True})
        return EvalResult("exit_code", False, signal)
    signal.update({"exit_code": proc.returncode, "timed_out": False})
    return EvalResult("exit_code", proc.returncode == expect, signal)


def diff_stats(
    base: str | Path,
    changed: str | Path,
    max_files: int | None = None,
    max_insertions: int | None = None,
    max_deletions: int | None = None,
) -> EvalResult:
    """Diff two trees (no .git needed); pass iff churn stays within every given cap.

    Uses `git diff --no-index --numstat`, whose exit 1 means "trees differ" —
    data, not error. Binary files count toward files, zero toward lines.
    """
    caps = {"max_files": max_files, "max_insertions": max_insertions, "max_deletions": max_deletions}
    proc = subprocess.run(
        ["git", "diff", "--no-index", "--numstat", "--", str(base), str(changed)],
        capture_output=True,
        text=True,
    )
    if proc.returncode not in (0, 1):
        return EvalResult(
            "diff_stats", False, {**caps, "error": proc.stderr.strip()[:200], "exit_code": proc.returncode}
        )
    files = insertions = deletions = 0
    for line in proc.stdout.splitlines():
        parts = line.split("\t")
        if len(parts) < 3:
            continue
        files += 1
        ins, dels = parts[0], parts[1]
        insertions += 0 if ins == "-" else int(ins)
        deletions += 0 if dels == "-" else int(dels)
    measured = {"files": files, "insertions": insertions, "deletions": deletions}
    within = (
        (max_files is None or files <= max_files)
        and (max_insertions is None or insertions <= max_insertions)
        and (max_deletions is None or deletions <= max_deletions)
    )
    return EvalResult("diff_stats", within, {**caps, **measured})


def token_count(paths: list[str | Path], max_tokens: int, root: str | Path | None = None) -> EvalResult:
    """Pass iff the summed token weight of paths is within max_tokens.

    Token proxy: ceil(utf8_bytes / 4) — deterministic and model-agnostic; a
    budget yardstick, not a tokenizer. Directories are walked recursively in
    sorted order. A missing path fails closed: a budget over absent files is
    a broken premise, not a pass.
    """
    base = Path(root) if root is not None else None
    total_bytes = 0
    counted = 0
    missing: list[str] = []
    for p in paths:
        path = (base / p) if base is not None else Path(p)
        if not path.exists():
            missing.append(str(p))
            continue
        files = sorted(f for f in path.rglob("*") if f.is_file()) if path.is_dir() else [path]
        for f in files:
            total_bytes += f.stat().st_size
            counted += 1
    tokens = math.ceil(total_bytes / 4)
    signal = {"tokens": tokens, "max_tokens": max_tokens, "files": counted, "missing": missing}
    return EvalResult("token_count", not missing and tokens <= max_tokens, signal)


def file_exists(root: str | Path, required: list[str], forbidden: list[str] = ()) -> EvalResult:
    """Pass iff every required path exists under root and no forbidden path does."""
    base = Path(root)
    missing = [p for p in required if not (base / p).exists()]
    present_forbidden = [p for p in forbidden if (base / p).exists()]
    signal = {"missing": missing, "present_forbidden": present_forbidden, "required": len(required)}
    return EvalResult("file_exists", not missing and not present_forbidden, signal)
