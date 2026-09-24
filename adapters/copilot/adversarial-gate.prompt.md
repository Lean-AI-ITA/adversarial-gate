---
description: A planning gate that runs BEFORE starting multi-step or costly work. Forces a structured, round-capped adversarial review with the user, a cost estimate, and a calibration ledger before anything executes.
---

# Adversarial Gate — GitHub Copilot

Before doing anything else: read `core/GATE.md` in this repository and
follow it. It has the rules, the review protocol, the cost discipline and
the calibration reconciliation. Nothing here duplicates it — this file only
adds what's specific to Copilot.

## Execution Model (Copilot)

Copilot Chat / Copilot coding agent runs **one agent per session**. There is
no built-in primitive for spawning several agents that report back into a
shared context, comparable to Claude Code's subagents.

- Treat `core/GATE.md`'s agent design as sequential passes by this one
  agent unless the specific Copilot surface you're running in (coding agent,
  multi-file edits) documents genuine parallel execution — check current
  docs rather than assuming.
- Where the plan needs an isolated verifier, open a **separate chat
  session** with no shared history and give it only the plan, not the
  reasoning behind it. Disclose that this is a weaker isolation than a truly
  separate agent context.

**Effort (§1.3):** Copilot doesn't expose reasoning effort as a dial separate
from model choice, as of this writing. Fold intensity into which model you
pick per agent instead of inventing a second knob — check current docs if
that's changed.

## Activation

Place this file at `.github/prompts/adversarial-gate.prompt.md`. Copilot
discovers prompt files at startup and exposes them as `/adversarial-gate` in
Copilot Chat, using the `description` above for the picker.

For a durable, always-loaded version of the same gate (rather than one you
invoke explicitly), add the relevant parts to `.github/copilot-instructions.md`
instead — but keep `core/GATE.md` as the single source of truth and reference
it from there, don't copy its text in.
