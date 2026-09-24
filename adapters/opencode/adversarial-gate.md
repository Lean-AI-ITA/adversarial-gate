---
description: A planning gate that runs BEFORE starting multi-step or costly work. Forces a structured, round-capped adversarial review with the user, a cost estimate, and a calibration ledger before anything executes.
---

Before doing anything else: read `core/GATE.md` in this project and follow
it. It has the rules, the review protocol, the cost discipline and the
calibration reconciliation. Nothing here duplicates it — this file only adds
what's specific to OpenCode.

## Execution Model (OpenCode)

OpenCode natively supports primary agents launching **subagents** — the
closest of any adapter in this repo to Claude Code's engine. `subagent_depth`
(default 1) caps how deep that nesting goes.

- Use this natively: design agents the way `core/GATE.md` §1.3 describes,
  define each one as a markdown file under `.opencode/agents/`, and invoke
  them from the primary session for the plan being gated.
- There is no OpenCode equivalent of Claude Code's "agent teams" (continuous
  peer dialogue) or "dynamic workflows" (scripted deterministic loops). If
  the analysis genuinely needs either, fall back to sequential single-agent
  passes and say so in STEP 2 rather than forcing a fit.

**Isolated self-critique (§2.2):** a genuine subagent, not a fresh session —
this is one of the two adapters in this repo (with Claude Code) that can
offer real isolation natively.

## Activation

Place this file at `.opencode/commands/adversarial-gate.md` (project) or
`~/.config/opencode/commands/adversarial-gate.md` (global). The filename
becomes the command id, invoked as `/adversarial-gate` from the OpenCode
session — the same discovery mechanism OpenCode uses for any custom command.

For a durable, always-loaded version rather than one you invoke explicitly,
add a pointer to `core/GATE.md` in this project's `AGENTS.md` instead — keep
`core/GATE.md` itself as the only copy of the actual rules.
