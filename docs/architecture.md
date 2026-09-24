# Architecture

The whole point of this skill is the shape of the diagram below: **three gates
in a row, and nothing crosses one without you.**

## Full flow

```mermaid
flowchart TD
    U(["<b>YOU</b><br/>“I want to build X”"])

    subgraph S1 ["STEP 1 — DESIGN THE ANALYSIS <i>(nothing runs)</i>"]
        direction TB
        A1["Ask “What do you want to achieve?”<br/>Model the problem"]
        A2["Design N agents — justified, never a default<br/>Select composable patterns"]
        A3["Choose ENGINE for ANALYSIS<br/><i>subagents · agent teams · dynamic workflow</i>"]
        A4["Estimate TOKENS<br/><i>typical / worst case — labelled ASSUMPTION</i>"]
        A1 --> A2 --> A3 --> A4
    end

    subgraph S2 ["STEP 2 — PROPOSAL"]
        B1["Show the plan: agents · workflow · patterns · engine · cost<br/><i>including why NOT the other engines</i>"]
    end

    ADV{{"<b>ADVERSARIAL REVIEW</b><br/>you attack the plan — it defends or revises<br/>it must also contest its own weakest assumption<br/><b>hard cap: 3 rounds · zero execution</b>"}}

    G1{"<b>GATE — do you confirm?</b>"}
    RE["REVISE<br/><i>back to review<br/>remaining rounds only</i>"]

    FORK(["<b>FORK</b>"])

    subgraph PA ["PATH A — HANDOFF"]
        PA1["Handoff brief<br/>scope · work packages · dependencies"]
        PA2["<b>+ record of the review</b><br/><i>what you objected, what changed</i>"]
        PA3(["Hand off to a spec-driven tool<br/><b>and stop</b>"])
        PA1 --> PA2 --> PA3
    end

    subgraph PB ["PATH B — ASSISTED EXECUTION"]
        direction TB
        PB1["Re-assess ENGINE for BUILDING<br/><i>independent decision</i>"]
        PB2["Goal &amp; Loop — stop conditions + hard caps"]
        PB3["Re-estimate TOKENS"]
        PB4{"<b>GATE — final confirmation</b>"}
        PB5["Execute → Verify → Loop → Synthesise"]
        PB6["Traceability: run_trace.md"]
        PB7["<b>Reconcile estimate vs actual</b><br/><i>and record why they differed</i>"]
        PB1 --> PB2 --> PB3 --> PB4 --> PB5 --> PB6 --> PB7
    end

    OUT(["Final deliverable"])

    U --> S1 --> S2 --> ADV --> G1
    G1 -- "not yet" --> RE
    RE -.-> ADV
    G1 -- "confirmed" --> FORK
    FORK -- "“I'll build it”" --> PA
    FORK -- "“you build it”" --> PB
    PB7 --> OUT

    classDef gate fill:#c0392b,stroke:#7b241c,stroke-width:2px,color:#fff
    classDef advers fill:#1a2b3c,stroke:#0d1a26,stroke-width:3px,color:#fff
    classDef work fill:#eaf0f4,stroke:#8fa6b8,color:#1a2b3c
    classDef pathA fill:#8e44ad,stroke:#5b2c6f,color:#fff
    classDef pathB fill:#16a085,stroke:#0e6655,color:#fff
    classDef terminal fill:#2c3e50,stroke:#1a2b3c,color:#fff

    class G1,PB4 gate
    class ADV advers
    class A1,A2,A3,A4,B1 work
    class PA1,PA2 pathA
    class PB1,PB2,PB3,PB5,PB6,PB7 pathB
    class U,OUT,PA3,FORK terminal
```

## Reading the diagram

**Three red gates and one dark box.** The dark box is the adversarial review;
the red shapes are the points where the system stops and waits for you. Every
other node is work that happens *between* gates. If you remember one thing:
**no node crosses a gate on its own initiative.**

**The engine is chosen twice, and they are independent decisions.** Once to
analyse (STEP 1), once to build (PATH B). Analysis is almost always light work,
so it defaults to subagents; the three engines only really differ under the
weight of construction. Choosing the build engine in STEP 1 is the most common
way to over-engineer a plan.

**PATH A ends in a stop, not a deliverable.** It hands off. The one thing it
carries forward that no spec-driven tool produces is the *record of the review* —
the audit trail of why the plan looks the way it does.

**PATH B ends in a reconciliation, not an artefact.** The estimate from STEP 1
gets checked against reality and the gap gets explained. An estimate that is
never reconciled is theatre.

## The loop discipline

Two loops exist in this system and both are capped, for the same reason:

| Loop | Soft stop | Hard cap | On cap |
|---|---|---|---|
| Adversarial review | plan is agreed | **3 rounds** | consolidate best version, go to gate |
| Execution loop (Path B) | checklist satisfied / no new useful work | `max_iterations`, `max_agents`, `max_token_budget` | stop, declare partial state, list what's missing |

An uncapped review is an argument. An uncapped execution loop is a bill.

## Where this sits

```mermaid
flowchart LR
    I(["intent"]) --> AG["<b>Adversarial Gate</b><br/><i>should we, and at what cost?</i>"]
    AG --> SD["spec-driven tools<br/><i>what exactly, in what order</i>"]
    SD --> RT["execution runtimes<br/><i>build it</i>"]
    RT --> D(["deliverable"])

    classDef me fill:#1a2b3c,stroke:#0d1a26,stroke-width:3px,color:#fff
    classDef other fill:#eaf0f4,stroke:#8fa6b8,color:#1a2b3c
    classDef term fill:#2c3e50,color:#fff
    class AG me
    class SD,RT other
    class I,D term
```

This skill occupies the leftmost box only, deliberately. See
[`../REFERENCES.md`](../REFERENCES.md) for what to use downstream.
