---
description: A planning gate that runs BEFORE starting multi-step or costly work. Forces a structured, round-capped adversarial review with the user, a cost estimate, and a calibration ledger before anything executes.
argument-hint: <goal>
---

# Adversarial Gate — Codex CLI

Before doing anything else: read `core/GATE.md` in this repository and
follow it. It has the rules, the review protocol, the cost discipline and the
calibration reconciliation. Nothing here duplicates it — this file only adds
what's specific to Codex CLI.

Goal, if given as an argument: $ARGUMENTS

## Execution Model (Codex CLI)

Codex CLI runs **one agent per session**. There is no evidence, as of this
writing, of a built-in primitive for spawning several agents that report
back into a shared context — check current Codex docs before assuming
otherwise, they move fast.

- Treat `core/GATE.md`'s agent design as sequential passes by this one
  session.
- Where the plan needs an isolated verifier, open a **second `codex`
  session** against the same repo, give it only the plan, and ask it to
  attack it. Disclose that this is a weaker isolation than a genuinely
  separate agent context.

**Effort (§1.3):** some models Codex CLI can run expose their own
reasoning-effort parameter independent of model choice — check your current
config for it rather than assuming it's there or not. If it's available,
route it per agent like model choice; if it isn't, fold intensity into which
model you pick instead.

## Activation

Two complementary mechanisms:

- **Durable context:** add a short pointer to `core/GATE.md` in this
  project's `AGENTS.md` (or `~/.codex/AGENTS.md` for a global default), so
  Codex reads the gate's existence on every session without you invoking it.
- **Explicit invocation:** place this file at `~/.codex/prompts/adversarial-gate.md`
  (or the project-local prompts directory). Codex discovers it at startup
  and exposes it as `/prompts:adversarial-gate` in the slash-command menu,
  using `description` above for the listing.

Note: OpenAI has signalled custom prompts are being superseded by a
"skills" mechanism closer to Claude Code's. If that's live when you read
this, prefer it — check current docs rather than trusting this adapter's
plumbing over the gate logic in `core/GATE.md`, which is what actually
matters.
