# Adversarial Gate

![The contradictory review: one objection accepted, one refused with a reason](assets/hero-contradictory-review.png)

**A planning gate that runs before any agent is spawned.**
It designs the analysis, estimates the token cost, and forces a structured
adversarial review with you — capped at 3 rounds. Nothing executes without your
explicit approval.

> Most agent tooling optimises for *starting faster*.
> This one optimises for **not starting wrong**.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Why it's different

| | |
|---|---|
| 🛑 **Human-in-the-loop, not model-in-the-loop** | The adversarial review happens with **you**, capped at 3 rounds — not with another LLM marking its own homework |
| 💰 **Cost is a first-class citizen** | Every plan ships a typical/worst-case token estimate, explicitly labelled as an assumption, before anything runs |
| 📈 **Self-calibrating** | Estimated vs actual tokens are reconciled after every build and logged to [`CALIBRATION.md`](CALIBRATION.md) — the skill gets better at guessing over time, and admits it out loud when it isn't yet |
| 🖐️ **Handbrake on critical risk** | Security, irreversibility, minors'/sensitive data, budget, legal exposure — these stop the flow outright instead of waiting their turn in the round cap |
| 🕵️ **Contests itself, in isolation** | Above trivial complexity, self-critique runs as an isolated adversary subagent — not the same context defending the plan it just wrote |
| 🧩 **Proportional, not performative** | Trivial request → 1 agent, out of the way. Product-code request → a justified 5-role preset, trimmed by argument, never assumed |
| 🏗️ **Agent architecture is designed, not templated** | Every agent gets an ID, a role, an objective and a model tier, decided from scratch per request — never a fixed roster copy-pasted across plans |
| 🔀 **Two ways out, both execution-aware** | **PATH A** hands off a structured brief to a spec-driven PRD tool; **PATH B** builds directly, choosing the execution model your harness actually offers — picked twice, once for the analysis, once for the build, and justified both times |
| 🌐 **One gate, six harnesses** | Claude Code, Cursor, Copilot, Codex CLI, OpenCode, Aider — same `core/GATE.md`, one adapter per harness for what genuinely differs (isolation, invocation, whether subagents exist at all) |
| 🤝 **Hands off instead of competing** | Writes no PRD of its own — produces a handoff brief carrying the one artefact nobody else keeps: the record of the review |
| 📋 **Reads like a gate, not a wall of text** | Tables for anything with more than two data points, every approval point marked as a visible stop, lettered A/B menus instead of open questions — see §2.1.1 in `core/GATE.md` |

## The problem

Agentic coding tools are extremely good at beginning work. You describe a goal,
and within seconds a fleet of subagents is running, burning tokens against an
interpretation of your request that nobody ever checked.

The failure mode is rarely bad execution. It is **excellent execution of the
wrong plan** — and you only find out after paying for it.

## What this does

```mermaid
flowchart TD
    U(["<b>YOU</b><br/>“I want to build X”"])
    P["<b>Design the analysis</b><br/>agents · patterns · engine · token estimate<br/><i>nothing runs</i>"]
    ADV{{"<b>ADVERSARIAL REVIEW</b><br/>you attack the plan — it defends or revises<br/>it must also contest its own weakest assumption<br/><b>3 rounds max · zero execution</b>"}}
    G{"<b>GATE — do you confirm?</b>"}
    A["<b>PATH A</b> — handoff brief<br/><i>+ the record of the review</i>"]
    B["<b>PATH B</b> — re-assess engine, re-estimate,<br/>confirm again, execute with traceability<br/><i>+ estimate vs actual reconciliation</i>"]

    U --> P --> ADV --> G
    G -- "not yet" --> ADV
    G -- "“I'll build it”" --> A
    G -- "“you build it”" --> B

    classDef gate fill:#c0392b,stroke:#7b241c,stroke-width:2px,color:#fff
    classDef advers fill:#1a2b3c,stroke:#0d1a26,stroke-width:3px,color:#fff
    classDef work fill:#eaf0f4,stroke:#8fa6b8,color:#1a2b3c
    classDef pathA fill:#8e44ad,stroke:#5b2c6f,color:#fff
    classDef pathB fill:#16a085,stroke:#0e6655,color:#fff
    classDef term fill:#2c3e50,color:#fff
    class G gate
    class ADV advers
    class P work
    class A pathA
    class B pathB
    class U term
```

See it in a full session below. Full flow, loop caps and where this sits in the ecosystem:
[`docs/architecture.md`](docs/architecture.md).

Three properties, in order of how much they matter:

1. **Adversarial review with the human.** The plan must survive your objections
   before a single token is spent on it. The skill is also required to surface
   its own weakest assumption each round — the ones an analyst doesn't notice
   are the ones that sink the work.
2. **Cost made discussable.** Every plan arrives with a typical/worst-case token
   estimate, explicitly labelled as an assumption. Over budget? It proposes a
   reduced version before asking for approval.
3. **Estimate reconciliation, written to a calibration ledger.** After a build,
   it reports estimated vs actual tokens and the cause of the gap, then appends
   the run to [`CALIBRATION.md`](CALIBRATION.md) — and **reads that file before
   the next estimate**. Below three runs on an engine it tells you outright that
   its numbers are uncalibrated. Estimates you never check are theatre; a ledger
   you never read back is just a diary.

## Install

One clone, then pick your harness — the gate logic in `core/GATE.md` is the
same everywhere; only how it's invoked differs.

```bash
git clone https://github.com/Lean-AI-ITA/adversarial-gate.git
cd adversarial-gate
./install.sh
```

`install.sh` detects likely harnesses from what's already in your project
(`.cursor/`, `.github/`, `~/.codex`, `.opencode/`, `.aider.conf.yml`,
`~/.claude`) and asks you to confirm, or skip straight to one:

```bash
./install.sh --harness=claude-code   # or: cursor | copilot | codex | opencode | aider
```

| Harness | Invocation | Isolation for self-critique |
|---|---|---|
| **Claude Code** | auto, by description — or `/adversarial-gate` | true isolated subagent |
| **Cursor** | Agent Requested rule — or `@adversarial-gate` | fresh chat (weaker) |
| **GitHub Copilot** | `/adversarial-gate` in Copilot Chat | fresh chat (weaker) |
| **Codex CLI** | `/prompts:adversarial-gate` — or via `AGENTS.md` | fresh session (weaker) |
| **OpenCode** | `/adversarial-gate` | true subagent |
| **Aider** | `/read` or `.aider.conf.yml` `read:` | fresh session (weaker) |

No adapter for your tool? `AGENTS.md` at the repo root is read natively by
several harnesses (Codex, OpenCode) with no install step at all, and is a
reasonable starting point to write your own adapter against `core/GATE.md`.

Then simply describe a goal. The gate activates when you state an objective
large enough that the obvious move would be to start producing immediately.

## See it work

A full annotated session — including the moment the gate refuses to proceed and
the user's objection changes the architecture — is in
[`examples/session-transcript.md`](examples/session-transcript.md).

## What this is *not*

This is a deliberately small piece. It is **complementary**, not competitive:

| You want | Use |
|---|---|
| A full spec-driven development lifecycle | GitHub Spec Kit |
| PRD → task graph decomposition and tracking | Task Master |
| Production runtime, budgets, approval workflows at infra level | Shannon |
| Adversarial review of code that's already written | adversarial-review skills (Dzazaleo, lemon03390, others — see `REFERENCES.md`) |
| **A cheap, conversational gate that makes you justify the plan and the spend before any of the above start** | **this** |

It does not write its own requirements document. Path A produces a compact
handoff brief and points you at the tools above — with one thing they don't
produce: **the record of the contradictory review**, i.e. which objections were
raised and how they were resolved.

See [`REFERENCES.md`](REFERENCES.md) for the landscape and for links to the
official engine documentation (which this skill deliberately does not duplicate).

## Is this for you?

Honest self-assessment, not a pitch:

- **You'll like it if** an agent has ever executed a plan flawlessly and you
  still got the wrong thing — and you'd rather spend 90 seconds justifying a
  plan than an afternoon undoing one.
- **You won't like it if** you want agents to just go, and any pause reads as
  friction rather than insurance. That's a legitimate preference, not a bug
  report — this gate is built to get out of the way on trivial requests (see
  *Proportional* below), but it will never fully disappear on non-trivial ones.
  It's friction sold on purpose, to people who've already paid for the
  alternative once.
- **It assumes** you're already doing multi-step, agentic work — orchestrating
  subagents, or just running a long agentic session in Cursor, Copilot, Codex,
  OpenCode or Aider. If you're not there yet, the cost estimate and
  calibration ledger won't mean much — install it when that becomes true, not
  before.
- **Especially relevant if you run local or self-hosted models.** Token cost
  there isn't an abstract line on a bill — it's your own GPU, your own
  electricity, your own twenty minutes watching inference run on the wrong
  architecture. The cost-before-execution discipline hits harder when the
  alternative is felt directly on your own hardware. The Aider adapter is
  built for exactly this case — one caveat, honestly stated there: it has no
  subagent isolation to offer, only a fresh session, which is weaker.

## Design notes

- **Proportional.** If a request is trivial, the gate says so and gets out of
  the way. A gate that fires on everything is a tax, not a control.
- **Harness-agnostic core, harness-specific execution.** `core/GATE.md` never
  names a specific engine — each adapter's Execution Model does that, twice,
  for different purposes: once to *analyse*, once to *build*. On Claude Code
  that's subagents / agent teams / dynamic workflows; on a single-agent
  harness like Aider it's honestly "there is no choice, you're the only
  agent." Analysis is almost always light regardless of harness.
- **Epistemically labelled.** Every claim is marked Evidence / Inference /
  Assumption / Uncertainty. Estimates are never dressed up as measurements.
- **No unbounded loops.** Every loop carries a soft stop condition *and* a hard
  cap, and declares a partial state on cap.
- **Handbrake, not a round.** An objection touching security, irreversibility,
  minors'/sensitive data, budget or legal exposure stops the flow outright —
  it does not wait its turn in the 3-round cap.
- **The critique doesn't mark its own homework either.** Past trivial
  complexity, the self-critique in the review runs as an isolated adversary
  subagent, not as the same context that designed the plan talking to itself.
- **A preset, not a constant.** For user-facing product code, the default
  starting slate is five roles — UX/product design, refactoring & performance,
  security, product/user-needs liaison, and a scout for reusable prior art —
  each cut or kept by argument in the review, never assumed.
- **Every agent gets a one-line Mandate, not just a label.** ID, name, role
  and what it actually does — the same clarity the Product Build roster
  already had, generalised to every agent in every plan.
- **The plan has to show its own cheapest shape.** Alongside the agent table,
  a short rationale ties the agent count, patterns and execution model back
  to cost — naming what was deliberately left out, not just what's in.
- **Scope direction is tracked, not just scope change.** `CALIBRATION.md` logs
  whether review objections shrank the plan, grew it, or just rearranged
  it — a review that only ever grows the plan back isn't earning its keep.
- **One checkpoint mid-build, only where the risk justifies it.** Complex
  builds pause once, after the first work package, before the rest of the
  budget is spent. Simple and Medium run straight through — a checkpoint
  there would be cost with no risk behind it to justify it.
- **Model and effort are two knobs, not one.** Every agent gets a model tier
  *and*, where the harness exposes it, an independent reasoning-effort
  level — a narrow classifier at low effort and a security verifier at high
  effort can coexist in the same plan without either being wasteful.
- **Performance earns the role more trust, not the instance more scope.**
  Agent IDs don't survive past their own run, so nothing is "promoted"
  mid-build — an agent proving capable of more gets re-gated like any other
  adjacent work. What persists is `CALIBRATION.md`'s role-performance table,
  which calibrates how the *next* run designs that role.
- **A role graduates to a reusable template at 3 runs, same threshold as the
  engine correction factor.** Saves the cost of designing from a blank page —
  never the scrutiny. A template still gets justified and challenged in
  STEP 2 like any agent designed from nothing.

## Contributing

Objections welcome — it would be somewhat ironic otherwise. Particularly
interested in: calibration data from real
reconciliation tables, and cases where the gate fired when it shouldn't have.

## License

MIT — see [LICENSE](LICENSE).
