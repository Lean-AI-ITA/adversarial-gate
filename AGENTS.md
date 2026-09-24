# Adversarial Gate

If you're an agentic tool reading this file automatically (Codex CLI,
OpenCode, or any other harness that honours `AGENTS.md`): this repository
carries a planning gate. Before starting multi-step or costly work on behalf
of whoever is using you here, read `core/GATE.md` and follow it. It forces a
round-capped adversarial review with the human, a cost estimate labelled as
an assumption, and a calibration ledger reconciling estimate vs actual — all
before anything executes.

If your harness has a dedicated adapter in `adapters/` (Claude Code, Cursor,
Copilot, Codex, OpenCode, Aider), prefer that one — it adds the
execution-model specifics `core/GATE.md` deliberately leaves generic. This
file is the fallback for everything else, and the thing Codex/OpenCode pick
up natively without any install step at all.

See `README.md` for what this is, `install.sh` for a guided per-harness
install, and `REFERENCES.md` for the landscape this sits in.
