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

```bash
git clone https://github.com/Lean-AI-ITA/adversarial-gate.git
mkdir -p ~/.claude/skills
cp -r adversarial-gate ~/.claude/skills/
```

Then simply describe a goal. The skill activates when you state an objective
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

## Design notes

- **Proportional.** If a request is trivial, the gate says so and gets out of
  the way. A gate that fires on everything is a tax, not a control.
- **Engine-agnostic.** It chooses between subagents / agent teams / dynamic
  workflows twice, for different purposes: once to *analyse*, once to *build*.
  Analysis is almost always light; the engines only really differ on the build.
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

## Contributing

Objections welcome — it would be somewhat ironic otherwise. Particularly
interested in: calibration data from real
reconciliation tables, and cases where the gate fired when it shouldn't have.

## License

MIT — see [LICENSE](LICENSE).
