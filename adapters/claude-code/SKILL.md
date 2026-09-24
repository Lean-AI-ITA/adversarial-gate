---
name: adversarial-gate
description: A planning gate that runs BEFORE any agent is spawned. It designs the analysis, estimates the token cost, and forces a structured adversarial review (max 3 rounds) with the user. Nothing executes without explicit approval. Use when the user describes a goal ("I want to build X", "analyse Y") and you are tempted to immediately start working, spawn subagents, or launch a dynamic workflow.
license: MIT
---

# Adversarial Gate — Claude Code

Before anything else: **read `core/GATE.md`** (in this same skill folder) and
follow it. It has the rules, the review protocol, the cost discipline and the
calibration reconciliation. Nothing here duplicates it — this file only adds
what's specific to Claude Code.

## Execution Model (Claude Code)

Claude Code offers three execution engines. **Do not restate their mechanics
here — read the official documentation, it changes.** See `REFERENCES.md`.

Decision tree:

```
A few tasks over a couple of turns?                  → SUBAGENTS   (default)
Continuous peer dialogue / shared task list needed?  → AGENT TEAMS (warn: experimental)
More than a handful of agents, deterministic
loops/branching, or script-level reproducibility?    → DYNAMIC WORKFLOWS
```

Prefer **dynamic workflows** when intermediate results would otherwise
saturate the orchestrator's context: the script holds the loop, branching and
state, and only the final answer returns to the context. Be aware this engine
is token-hungry — start narrow.

This is the engine you plug into `core/GATE.md` §1.5 and §Path B step 1 —
choose it twice, independently, once for the analysis and once for the build.

**Isolated self-critique (§2.2):** Claude Code supports true isolated-context
subagents natively — use one for the adversary role above Simple complexity,
not a fresh top-level session. It is the strongest isolation any adapter in
this repo can offer.

**Slash-command invocation:** copying this skill's `name:` field makes it
invocable as `/adversarial-gate`, on top of the automatic trigger from
`description:` above.
