# Adversarial Gate — Aider

**Read this together with `core/GATE.md`** (load both as read-only context —
see Activation below). This file only says what's specific, and different,
about running the gate inside Aider.

## What's different here — read this before assuming parity

Aider is **one model, one conversational thread, no subagent spawning, no
execution engine to choose**. That changes how much of `core/GATE.md`
actually applies:

- **§1.3 "Design the agents"** — there is only one agent: you. Read it as a
  checklist of hats you wear in sequence (analyst, then critic, then
  builder), never as roles that could run in parallel. Say this out loud in
  STEP 2 rather than presenting sequential passes as independent work.
- **§1.3.1 Product Build roster** — same: five sequential passes over the
  plan, not five workers.
- **§1.4 patterns / §1.5 execution model / Path B step 1** — mostly
  **not applicable**. Aider has no execution model to choose between; skip
  these decisions rather than inventing an engine choice that doesn't exist.
- **§2.2 isolated self-critique** — Aider cannot spawn an isolated context
  from inside a running session. The nearest honest equivalent is starting a
  **fresh Aider session** (new invocation, no `--restore-chat-history`),
  given only the plan text, not the reasoning that produced it, and asked to
  attack it. This is meaningfully weaker isolation than a true separate
  agent — say so explicitly if you use it, per `core/GATE.md`'s own epistemic
  discipline (don't present a weak isolation as if it were a strong one).
- **Cost estimate (§1.6) and calibration (`CALIBRATION.md`)** — these still
  apply, and matter more here, not less: if you're running a local model
  through Aider, "tokens" is your own compute time. Use tokens if your setup
  exposes them, otherwise wall-clock time as the proxy, and say which one
  you're using.
- **The review itself (§2), the handbrake (rule 6), and the handoff brief
  (Path A)** — apply exactly as written. None of that depends on multi-agent
  orchestration.
- **Effort (§1.3)** — moot for the *agent count* axis (there's only one of
  you), but some models Aider can drive do expose their own reasoning-effort
  setting (check `.aider.conf.yml` for a `reasoning-effort`-style option
  against the model you've configured). If yours does, that's your one real
  effort knob for this harness; if it doesn't, there isn't one to fake.

## Activation

Aider has no skill-discovery or custom-slash-command system. Load both files
as read-only context, either per-session:

```
/read core/GATE.md
/read adapters/aider/CONVENTIONS.md
```

or durably, in `.aider.conf.yml`:

```yaml
read:
  - core/GATE.md
  - adapters/aider/CONVENTIONS.md
```

Read-only means Aider can consult the rules while editing files but won't
rewrite them mid-session by accident.
