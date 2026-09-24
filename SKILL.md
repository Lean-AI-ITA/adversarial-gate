---
name: adversarial-gate
description: A planning gate that runs BEFORE any agent is spawned. It designs the analysis, estimates the token cost, and forces a structured adversarial review (max 3 rounds) with the user. Nothing executes without explicit approval. Use when the user describes a goal ("I want to build X", "analyse Y") and you are tempted to immediately start working, spawn subagents, or launch a dynamic workflow.
license: MIT
---

# Adversarial Gate

> Deliberate friction before autonomy.

Most agent tooling optimises for *starting faster*. This skill optimises for
**not starting wrong**. It sits upstream of the execution engines and refuses to
let work begin until the plan has been costed, contested and approved.

## When to use this skill

Trigger it when the user states a goal and the obvious move would be to begin
producing. Typical signals:

- "I want to build / analyse / migrate / document X"
- a request whose scope is larger than a single answer
- any situation where you are about to spawn subagents or a dynamic workflow

Do **not** trigger it for factual questions, single-file edits, or anything a
direct answer resolves. The gate is proportional: if the work is trivial, say so
and skip it. A gate that fires on everything is a tax, not a control.

## Absolute rules

1. **Never advance past a gate without explicit user approval.** Silence,
   ambiguity, or "ok go on" about a *different* topic is not approval.

   **A blanket authorisation does not dissolve later gates.** "Go all the way",
   "do everything", "don't stop to ask" — these are approvals of the scope
   currently on the table, not of scopes that have not yet been designed or
   costed. Acknowledge the intent, then keep gating:
   > *Understood — I'll minimise check-ins. I still need one confirmation per
   > work package, because I can't cost work I haven't designed yet.*

   A gate that a single up-front sentence can switch off is not a gate.
2. **Never execute during the contradictory review.** Only the plan is on the table.
3. **Never present an estimate as a measurement.** Token figures are assumptions
   until reconciled against real usage.
4. **Never generate the deliverable's own requirements document.** Hand off (see §Handoff).
5. The opening question is always *"What do you want to achieve?"* — never
   *"which agent should I use?"*. Agent, pattern and engine selection is the
   system's responsibility, not the user's.

---

## STEP 1 — Design the analysis

### 1.1 Ask first

On invocation, create nothing. Ask:

> *What do you want to achieve? Describe the goal freely.*

If the request is vague, ask **only** the missing questions — never a long
questionnaire. Useful dimensions: expected result, available material,
constraints, audience, required depth. If it is already clear, proceed.

### 1.2 Model the problem

| Dimension | Question |
|---|---|
| Objective | What must be produced? |
| Tasks | What activities are required? |
| Dependencies | What must precede what? |
| Parallelism | What can run concurrently? |
| Verification | Which outputs need an independent checker? |
| Comparison | Are multiple independent solutions worth contrasting? |
| Iteration | Must the result be refined to a threshold? |
| Scale | How many agents / iterations? (drives engine choice) |

### 1.3 Design the agents

Agent count is a **justified decision, never a constant**. If one agent is
enough, use one. Each agent gets a distinct, verifiable responsibility.

Specify per agent: *ID · Name · Role · Objective · Responsibilities · Input ·
Output · Skills · Quality criteria · Dependencies · Model*.

**Model routing** (cost containment):

| Tier | Use for |
|---|---|
| Fast / cheap | classifiers, rubric-based checkers, filters, simple judges |
| Mid | specialists, synthesisers |
| Top | only where deep reasoning genuinely changes the outcome |

> Exception worth remembering: do not cheap out on the agent whose job is to
> decide whether the work has value at all. A weak red-team produces weak
> objections and a false green light.

### 1.4 Workflow patterns (composable primitives)

| # | Pattern | Logic | Use when | Rule |
|---|---|---|---|---|
| 01 | Classify-and-Act | a classifier routes to the right agent | the task falls into a clear category | don't multiply agents if one suffices |
| 02 | Fan-out-and-Synthesize | split into sub-tasks, then synthesise | the problem splits into parallel parts | the synthesiser invents nothing: it separates evidence, inference and gaps |
| 03 | Adversarial Verification | one worker produces, verifiers hunt for errors | accuracy is critical | verifier needs an **explicit rubric** and an **isolated context** |
| 04 | Generate-and-Filter | generate alternatives, filter with a weighted rubric | creativity / options are needed | weighted rubric, deduplicate |
| 05 | Tournament | pairwise comparison to a winner | several plausible approaches | identical criteria for every candidate |
| 06 | Loop Until Done | iterate until a stop condition fires | the amount of work is unknown | stop condition **and** hard cap. Never unbounded |

Adversarial Verification only works if the verifier does **not** share the
producer's context — otherwise it marks its own homework. Isolated-context
subagents are what guarantee this.

### 1.5 Choose the engine for the ANALYSIS

Claude Code offers three execution engines. **Do not restate their mechanics
here — read the official documentation, it changes.** See `REFERENCES.md`.

Decision tree:

```
A few tasks over a couple of turns?                  → SUBAGENTS   (default)
Continuous peer dialogue / shared task list needed?  → AGENT TEAMS (warn: experimental)
More than a handful of agents, deterministic
loops/branching, or script-level reproducibility?    → DYNAMIC WORKFLOWS
```

Prefer **dynamic workflows** when intermediate results would otherwise saturate
the orchestrator's context: the script holds the loop, branching and state, and
only the final answer returns to the context. Be aware this engine is
token-hungry — start narrow.

> In STEP 1 the analysis is almost always light work → choose **subagents**
> unless there is an explicit reason not to. Justify the choice in one line,
> **including why not the other two.**

### 1.6 Estimate the token cost of the ANALYSIS

**Read `CALIBRATION.md` before estimating.** If it holds ≥3 runs for the chosen
engine, apply the derived correction factor and say so: *"adjusted ×1.4 from 7
prior runs"*. If it holds fewer, state plainly that the estimate is
**uncalibrated** for that engine. A confident number built on two data points is
worse than an honest shrug.

```
step_tokens     ≈ (input + output) × calls
ANALYSIS_TOKENS ≈ Σ step_tokens   (× loop iterations, worst case)
corrected       = raw × calibration_factor   (only when ≥3 runs exist)
```

Present a table with **two scenarios — typical and worst case** — and an
optional currency estimate.

**Label the whole table as an ASSUMPTION.** It is an LLM's guess, not telemetry.
Its purpose is to make cost *discussable*, not to be accurate. If the estimate
exceeds the user's budget, propose a reduced version before asking for approval.

---

## STEP 2 — Proposal and contradictory review

### 2.1 What to present

Show the plan. Execute nothing.

- **Interpreted objective** + Definition of Done
- **Strategy** — why this architecture
- **Agents** — table: ID · Agent · Role · Activity · Model
- **Workflow** — diagram
- **Patterns used** — with a justification each
- **Analysis engine** — with justification, including why not the others
- **Token estimate** — typical / worst case, flagged as assumption
- **Quality criteria** and expected analysis output

### 2.2 The contradictory review — the core of this skill

Then open the floor:

> *Do you have objections, doubts, or constraints I haven't considered?
> Challenge my choices: agents, patterns, engine, cost.*

- The user objects → you **defend with arguments** or **revise**. Caving
  instantly is as useless as refusing to move.
- **Hard cap: 3 rounds.** On round 3, consolidate the best version and move to
  the STEP 3 gate.
- **Also contest your own proposal.** Surface at least one weakness and one
  assumption you are making on the user's behalf. This is not humility theatre:
  the assumptions an analyst doesn't notice are the ones that sink the work.
- No execution during the review.

---

## STEP 3 — Approval gate, then handoff or build

Ask explicitly:

> **Do you confirm this analysis?** If so, how do you want to proceed?
> **A) I'll build it myself** → I'll hand off a structured brief to a spec-driven tool.
> **B) You build it** → I'll re-assess the engine for execution and re-estimate the cost.

No confirmation, no progress. If the user still wants changes → back to STEP 2
(remaining rounds only).

### PATH A — Handoff

This skill does **not** write its own requirements document. That problem is
solved better elsewhere. Produce a compact **handoff brief** (see
`templates/handoff-brief.md`) containing the confirmed objective, scope,
constraints, work packages, dependencies, acceptance criteria and — crucially —
the **record of the contradictory review**: which objections were raised and how
they were resolved. That record is the part no other tool produces.

Then point the user at a spec-driven implementation tool (see `REFERENCES.md`)
and stop.

### PATH B — Assisted execution

1. **Re-assess the engine for BUILDING.** This is an independent decision from
   §1.5 — analysis is light, construction usually isn't. Justify it again.

2. **Define Goal & Loop:**

```yaml
goal:
  deliverable: <concrete artefact>
  definition_of_done:
    - <verifiable criterion 1>
    - <verifiable criterion 2>
  non_goals:
    - <out of scope>

loop:                      # only if iteration is required
  stop_conditions:         # soft — any ONE is enough
    - checklist criteria satisfied
    - no new useful information or work
  hard_caps:               # always
    max_iterations: N
    max_agents: M
    max_token_budget: T
  on_cap_reached: "stop, declare partial state, report what is missing"
```

3. **Re-estimate tokens** for the build. Over budget → propose a reduced version.

4. **Final confirmation:**
   > *Proceed with the build via `<engine>`, with this Goal/Loop and an estimated
   > budget of ~T tokens?*

5. **Open `run_trace.md` BEFORE the first agent starts.** Not afterwards, not
   from memory. Log each task as it completes:

   `Task · Agent · Input · Output · Status · Verification · Score · Decision · Tokens`

   This ordering is the whole point: a `max_token_budget` nobody is measuring is
   a comment in a YAML block, not a cap. If you cannot observe token usage during
   the run, say so up front and downgrade the cap to what it actually is — an
   intention.

6. **Execute:** initialise agents → run → VERIFICATION → LOOP (hard-capped) →
   SYNTHESIS. Resolve conflicts with a judge using an identical rubric when the
   divergence touches the Definition of Done; if unresolvable, declare the
   uncertainty rather than picking arbitrarily.

   **Stop at the edge of `non_goals`.** If useful adjacent work appears —
   especially work you already listed as out of scope — do not absorb it into the
   current run. Finish, report, and re-gate it as its own package with its own
   estimate. Work that was never costed cannot have been approved, and mixing it
   in corrupts the reconciliation in step 8: you can no longer tell whether the
   estimate was good or whether two errors cancelled out.

7. **Estimate reconciliation — do not skip.** Close the run with:

   | | Estimated | Actual | Δ |
   |---|---|---|---|
   | Tokens | T_est | T_real | % |

   Record the cause of any significant gap. This is what turns §1.6 from a guess
   into a calibrated instrument over time, and it is the honest counterpart to
   presenting estimates at all.

8. **Append one row to `CALIBRATION.md`.** Non-negotiable, and the last thing
   you do. Log date, engine, agent count, estimate, actual, Δ%, and the primary
   cause of the gap. Recompute the correction factors every ~5 runs, and update
   the review-outcomes table.

   A run that isn't logged makes the next estimate no better than this one.

---

## Epistemic discipline (always on)

Label every claim:

| Label | Meaning |
|---|---|
| **Evidence** | backed by a verifiable source |
| **Inference** | derived by reasoning from evidence |
| **Assumption** | unverified, adopted to proceed |
| **Uncertainty** | not concluded |

Never present inferences or assumptions as established fact.

## Proportionality

| Complexity | Agents | Typical engine |
|---|---|---|
| Simple | 1 | single subagent, or just answer directly |
| Medium | 1 worker + 1 verifier + 1 synthesiser | subagents |
| Complex | classifier + parallel specialists + verifiers + judge + synthesiser + loop | dynamic workflow |

Both agent count and engine are justified decisions. Never defaults.
