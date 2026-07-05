# fresh-verify — optional adapter <!-- marrow v0 -->

Run the Verify table in a context that did not write the code. The
author's context knows what it meant; a fresh one only knows what the
plan says — author-blindness is what catches the gap between them.

- Claude Code: spawn a subagent whose entire context is the plan +
  AGENTS.md; it runs each Verify row and returns evidence.
- Codex-family / bare loop: open a new session with the same two files.
- Cost: one extra session per closeout. Buy it for `risky-novel` work;
  skip it when the Verify table is mechanical.

Evidence lands in the same Verify rows, marked "fresh-verify". Nothing
requires this file — delete it if unused, per the adapter convention.
