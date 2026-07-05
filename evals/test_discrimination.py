"""Discrimination suite — Phase 0's acceptance criterion, enforced as code.

Each dataset case pins one evaluator to one fixture state with an expected
verdict: known-bad states must be caught (passed == False), known-good ones
cleared. test_acceptance_criterion then re-derives the phase gate from the
datasets themselves: every evaluator shows >=1 catch and >=1 clear, across
>=2 fixtures — an evaluator that never discriminated proves nothing.
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

import pytest
import yaml

import evaluators

HERE = Path(__file__).resolve().parent
FIXTURES = HERE / "fixtures"
EVALUATORS = {"exit_code", "diff_stats", "token_count", "file_exists"}


def load_cases() -> list[tuple[str, dict]]:
    cases = []
    for ds_path in sorted((HERE / "datasets").glob("*.yaml")):
        ds = yaml.safe_load(ds_path.read_text())
        assert ds["evaluator"] in EVALUATORS, f"unknown evaluator in {ds_path.name}"
        cases.extend((ds["evaluator"], case) for case in ds["cases"])
    return cases


CASES = load_cases()


def dispatch(evaluator: str, inputs: dict, tmp_path: Path) -> evaluators.EvalResult:
    if evaluator == "exit_code":
        work = tmp_path / "tree"  # run in a copy so fixtures stay pristine
        shutil.copytree(FIXTURES / inputs["tree"], work)
        cmd = [sys.executable if a == "PY" else a for a in inputs["cmd"]]
        return evaluators.exit_code(cmd, cwd=work, expect=inputs.get("expect", 0))
    if evaluator == "diff_stats":
        return evaluators.diff_stats(
            FIXTURES / inputs["base"],
            FIXTURES / inputs["changed"],
            max_files=inputs.get("max_files"),
            max_insertions=inputs.get("max_insertions"),
            max_deletions=inputs.get("max_deletions"),
        )
    if evaluator == "token_count":
        return evaluators.token_count(
            inputs["paths"], inputs["max_tokens"], root=FIXTURES / inputs["root"]
        )
    if evaluator == "file_exists":
        return evaluators.file_exists(
            FIXTURES / inputs["root"], inputs["required"], inputs.get("forbidden", ())
        )
    raise ValueError(evaluator)


@pytest.mark.parametrize(
    ("evaluator", "case"), CASES, ids=[f"{e}:{c['name']}" for e, c in CASES]
)
def test_discrimination(evaluator: str, case: dict, tmp_path: Path) -> None:
    result = dispatch(evaluator, case["inputs"], tmp_path)
    expected = case["expected_output"]["passed"]
    assert result.passed == expected, f"want passed={expected}, got {result.to_json()}"


def test_acceptance_criterion() -> None:
    """bone-plan.md Phase 0 'Accepts when', derived from the datasets themselves."""
    seen: dict[str, dict[str, set]] = {}
    for evaluator, case in CASES:
        slot = seen.setdefault(evaluator, {"catch": set(), "clear": set()})
        kind = "clear" if case["expected_output"]["passed"] else "catch"
        slot[kind].add(case["metadata"]["fixture"])
    assert set(seen) == EVALUATORS, f"evaluator without cases: {EVALUATORS - set(seen)}"
    for evaluator, slot in seen.items():
        assert slot["catch"], f"{evaluator}: no failing case it catches"
        assert slot["clear"], f"{evaluator}: no passing case it clears"
        spanned = slot["catch"] | slot["clear"]
        assert len(spanned) >= 2, f"{evaluator}: cases span only {spanned}"
