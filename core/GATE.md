# Adversarial Gate — Core Rules

> Deliberate friction before autonomy.

This is the harness-agnostic spec. It is loaded by every adapter in
`adapters/` — Claude Code, Cursor, Copilot, Codex, OpenCode, Aider — and it
does not change per harness. What changes per harness is the **Execution
Model**: how many agents can actually run, and how. That part lives in your
adapter file, not here. If you were pointed at this file by an adapter, read
the adapter's own "Execution Model" section too — this file alone is
incomplete.

Most agent tooling optimises for *starting faster*. This gate optimises for
**not starting wrong**. It sits upstream of whatever executes your work and
refuses to let it begin until the plan has been costed, contested and
approved.

## When to use this gate

Trigger it when the user states a goal and the obvious move would be to begin
producing. Typical signals:

- "I want to build / analyse / migrate / document X"
- a request whose scope is larger than a single answer
- any situation where you are about to do multi-step, costly work on an
  interpretation of the request nobody has checked

Do **not** trigger it for factual questions, single-file edits, or anything a
direct answer resolves. The gate is proportional: if the work is trivial, say
so and skip it. A gate that fires on everything is a tax, not a control.

## Absolute rules

1. **Never advance past a gate without explicit user approval.** Silence,
   ambiguity, or "ok go on" about a *different* topic is not approval.

   **A blanket authorisation does not dissolve later gates.** "Go all the
   way", "do everything", "don't stop to ask" — these are approvals of the
   scope currently on the table, not of scopes that have not yet been
   designed or costed. Acknowledge the intent, then keep gating:
   > *Understood — I'll minimise check-ins. I still need one confirmation per
   > work package, because I can't cost work I haven't designed yet.*

   A gate that a single up-front sentence can switch off is not a gate.
2. **Never execute during the contradictory review.** Only the plan is on the
   table.
3. **Never present an estimate as a measurement.** Token/cost figures are
   assumptions until reconciled against real usage.
4. **Never generate the deliverable's own requirements document.** Hand off
   (see §Handoff).
5. The opening question is always *"What do you want to achieve?"* — never
   *"which agent should I use?"*. Agent design and execution-model selection
   is the system's responsibility, not the user's.
6. **A critical-domain objection is a handbrake, not a round.** If an
   objection — yours or the user's — touches an irreversible action, security,
   minors' or sensitive data, spend beyond the stated budget, or legal/
   regulatory exposure, do not fold it into the next round of §2.2. Stop, name
   the domain, and get an explicit answer to that point alone before anything
   else moves — even if review rounds remain.

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
| Scale | How much work, how many passes? (drives the execution-model choice in your adapter) |

### 1.3 Design the agents (or the passes, if you're the only one)

Agent count is a **justified decision, never a constant**. If one agent — or
one pass by the only agent you have — is enough, use one. Each unit of work
gets a distinct, verifiable responsibility, whether or not your harness can
run it as a separately spawned agent.

Specify per unit: *ID · Name · Role · Objective · Responsibilities · Input ·
Output · Skills · Quality criteria · Dependencies · Model · Effort (see
below, both if your harness supports them)*. This full spec is your working
notes — when you present in §2.1, compress Objective + Responsibilities into
the one-line **Mandate** the user actually reads. Keep the full spec around;
you'll need it if an agent gets challenged in §2.2 and you have to defend or
revise it with specifics, not vibes.

**Model and effort routing** (cost containment, where available) — **two
independent knobs, not one.** Model picks *which* capability; effort picks
*how hard* it thinks within that capability. Don't burn depth on a task that
doesn't need it, and don't assume a cheaper model needs more effort to
compensate for real complexity it can't actually handle — that's the wrong
knob for the problem.

*Model:*

| Tier | Use for |
|---|---|
| Fast / cheap | classifiers, rubric-based checkers, filters, simple judges |
| Mid | specialists, synthesisers |
| Top | only where deep reasoning genuinely changes the outcome |

*Effort (only where your harness exposes it as a separate dial — see your
adapter):*

| Level | Use for |
|---|---|
| Low | narrow, well-defined, low-ambiguity work — most classifiers, filters, single-purpose passes |
| Medium | default for specialist work where real judgment is involved |
| High / Max | correctness-critical or broad-coverage work — security/vulnerability verification, ambiguous calls, the isolated adversary in §2.2 |

> Exception worth remembering, on **both axes**: do not cheap out on the
> agent — or the pass — whose job is to decide whether the work has value at
> all, or to verify something security-critical. A weak red-team produces
> weak objections and a false green light; a red-team run at low effort
> fails the same way for a different reason.

**Who picks model and effort:** the system does, same as agent count and
everything else in §1.3 — justified in the table, open to challenge in
STEP 2 like any other line. The opening question is never "which model do
you want" any more than it's "which agent" (rule 5).

**If your harness cannot spawn separate agents at all** (see your adapter):
treat §1.3 as a checklist of hats the single agent wears in sequence, not
roles that run in parallel. Say so in STEP 2 rather than silently presenting
sequential passes as if they were independent.

### 1.3.1 Preset: Product Build roster

When the objective is to build something a user will directly use — a
feature, an app, a UI, a product surface — propose this five-role roster as
the **default starting slate**. It is a preset, not a constant: every role
still gets its one-line justification in STEP 2, and any role that doesn't
fit the request gets cut in the review, out loud, exactly like any other
agent (§1.3). Silence is not how an agent gets removed — an argument is.

| Role | Mandate | Cut it when |
|---|---|---|
| **UX/Product Designer** | Visual and interaction design, consistency | there is no user-facing surface (CLI flag, internal script, backend job) |
| **Refactoring & Performance Optimizer** | Code quality, structure, efficiency | the deliverable is throwaway, one-off, with no maintenance horizon |
| **Security Reviewer** | Vulnerabilities, secure-coding practice | no user input, no secrets, no network or data surface is touched |
| **Product & User-Needs Liaison** | Keeps the build anchored to who it's for and why; turns that into acceptance criteria | the request is purely internal/technical with no end user to serve |
| **Scout** | Searches existing repos, libraries and prior art before building, so nothing gets reinvented that already exists | the domain is novel or small enough that a search costs more than it saves |

A trivial script is still **1 agent (or 1 pass)** — the preset does not
override Proportionality below. For a Medium-or-above request whose goal is
user-facing product code, propose all five and let STEP 2 do the cutting. On
a harness with no subagent spawning, these five are five sequential passes,
not five parallel workers — say so.

### 1.4 Workflow patterns (composable primitives)

| # | Pattern | Logic | Use when | Rule |
|---|---|---|---|---|
| 01 | Classify-and-Act | a classifier routes to the right agent/pass | the task falls into a clear category | don't multiply agents if one suffices |
| 02 | Fan-out-and-Synthesize | split into sub-tasks, then synthesise | the problem splits into parallel parts | the synthesiser invents nothing: it separates evidence, inference and gaps |
| 03 | Adversarial Verification | one worker produces, verifiers hunt for errors | accuracy is critical | verifier needs an **explicit rubric** and an **isolated context** |
| 04 | Generate-and-Filter | generate alternatives, filter with a weighted rubric | creativity / options are needed | weighted rubric, deduplicate |
| 05 | Tournament | pairwise comparison to a winner | several plausible approaches | identical criteria for every candidate |
| 06 | Loop Until Done | iterate until a stop condition fires | the amount of work is unknown | stop condition **and** hard cap. Never unbounded |

Adversarial Verification only works if the verifier does **not** share the
producer's context — otherwise it marks its own homework. A true isolated
context (a separately spawned agent, or a fresh session with no shared
history) is what guarantees this. If your harness can only offer a fresh
session as the nearest equivalent — no separately addressable subagent — use
it, but disclose that the isolation is weaker than a genuinely separate
context.

### 1.5 Choose the execution model for the ANALYSIS

**This step is harness-specific — see your adapter's "Execution Model"
section for the concrete options.** Whatever your harness offers, justify the
choice in one line, **including why not the alternatives**, exactly as you
would any other decision in this gate. Do not restate engine mechanics here —
they change; read your harness's own documentation for the current behaviour.

> In STEP 1 the analysis is almost always light work → prefer the lightest
> option your harness offers unless there is an explicit reason not to.

### 1.6 Estimate the cost of the ANALYSIS

**Read `CALIBRATION.md` before estimating.** If it holds ≥3 runs for the
chosen execution model, apply the derived correction factor and say so:
*"adjusted ×1.4 from 7 prior runs"*. If it holds fewer, state plainly that the
estimate is **uncalibrated** for that model. A confident number built on two
data points is worse than an honest shrug.

```
step_cost     ≈ (input + output) × calls        # tokens, or wall-clock time / $ if tokens aren't visible to you
ANALYSIS_COST ≈ Σ step_cost   (× loop iterations, worst case)
corrected     = raw × calibration_factor   (only when ≥3 runs exist)
```

Present a table with **two scenarios — typical and worst case**. Use tokens
if your harness exposes them; if it doesn't, use the next best observable
proxy (wall-clock time, request count, $ if metered) and say plainly which
proxy you're using and why.

**Label the whole table as an ASSUMPTION.** It is a guess, not telemetry. Its
purpose is to make cost *discussable*, not to be accurate. If the estimate
exceeds the user's budget, propose a reduced version before asking for
approval.

---

## STEP 2 — Proposal and contradictory review

### 2.1 What to present

Show the plan. Execute nothing.

- **Interpreted objective** + Definition of Done
- **Strategy** — why this architecture
- **Agents/passes** — table: *ID · Name · Role · Mandate · Model (if
  applicable) · Effort (if your harness exposes it)*. **Mandate is one line,
  not a label** — what this unit actually does and why it exists, enough
  that the table alone explains the roster without cross-referencing §1.3.
  Same discipline the Product Build roster (§1.3.1) already uses — generalise
  it to every agent, not just that preset.
- **Workflow** — diagram
- **Design rationale — why this is the cheapest shape that still works.** One
  short paragraph tying the agent count, the patterns, the model/effort
  choices and the execution model back to cost: what was *not* added, and
  why — including why an agent that could have run at high effort didn't.
  "No dedicated classifier — only one input category, so cut" is the shape
  this takes. The estimate in §1.6 is a number; this is the reasoning that
  number is supposed to be the minimum of. If you can't name something you
  deliberately left out, you probably haven't minimised yet.
- **Patterns used** — with a justification each
- **Execution model** — with justification, including why not the alternatives
- **Cost estimate** — typical / worst case, flagged as assumption
- **Quality criteria** and expected analysis output

### 2.1.1 Presentation format

This is a gate, not a report — the human has to actually notice the decision
point and read it, not skim past it in scrollback. Format accordingly:

- **Tables for anything with more than two data points.** Agent roster, cost
  estimate, review record — a table, not a paragraph pretending to be a list.
  Consistent columns every time (§2.1's bullets give the columns).
- **One line of stakes before the plan, not after.** What's actually being
  decided, in plain language — "before this spends anything, here's the plan
  and here's where I could be wrong" — not a throat-clear. Say it once, don't
  pad it.
- **Self-critique gets a visual marker**, not buried in the prose — a short
  callout the eye catches before it starts skimming.
- **Every gate is visually a gate.** A rule (`---`) and a short bold header
  before any point that requires an explicit answer, so it reads as a stop
  sign, not another paragraph. Do this at STEP 2's open-floor question and at
  every confirmation in STEP 3.
- **Restraint, not decoration.** Confident and direct beats flashy. Tables
  and one deliberate marker per gate; not an emoji on every line. A gate
  dressed up as a show is exactly the "humility theatre" §2.2 already warns
  against, aimed at presentation instead of content — same failure, same
  fix: cut it.

### 2.2 The contradictory review — the core of this gate

**Order matters here — self-critique runs before the floor opens, not after.**
A critical-domain finding (rule 6) can only act as a handbrake if it's found
*before* the general question goes out; found after, it's just one more
reply in round 1, and the handbrake has nothing to interrupt.

1. **Contest your own proposal against a fixed checklist first, not free
   association.** Scan the plan against: *Security & data protection ·
   Irreversibility · Cost/budget · Legal or regulatory exposure ·
   Scalability/maintenance burden*. Surface whichever domains are actually
   live for this plan — usually one or two; forcing all five every time is
   theatre, not rigor. This is not humility theatre either way: the
   assumptions an analyst doesn't notice are the ones that sink the work.

   **Above Simple complexity (see Proportionality), don't run this
   self-critique from the same context that designed the plan.** Use the
   strongest isolation your harness offers — a spawned subagent if you have
   one, otherwise a fresh session with no shared history — whose only brief
   is to attack the proposal against that checklist. Same reasoning as the
   isolated verifier in Pattern 03 (§1.4): a plan that critiques itself
   marks its own homework — that failure mode isn't unique to code
   verification.

2. **Any finding that lands in rule 6's domains fires the handbrake right
   here, before step 3 below.** Stop, name the domain(s), ask only about
   that — one or more findings at once, all named together if several
   surfaced. Do not proceed to the general floor until it's answered.

3. **Only once step 2 is clear (nothing critical found, or a critical
   finding just got resolved) do you open the general floor:**

   > *Do you have objections, doubts, or constraints I haven't considered?
   > Challenge my choices: agents, patterns, execution model, cost.*

   Any non-critical self-critique findings from step 1 are folded in here,
   as the opening move of round 1 — not asked separately.

- The user objects → you **defend with arguments** or **revise**. Caving
  instantly is as useless as refusing to move.
- **Hard cap: 3 rounds**, counted from when the general floor opens in step
  3 — the handbrake exchange in step 2 doesn't spend one. On round 3 with
  objections still open, don't quietly fold them into "the best version."
  **Carry every unresolved objection forward by name**, into the handoff
  brief (§9) or the run trace, marked *deferred — cap reached*. A dropped
  objection and a resolved one must not look the same on paper.
- No execution during the review.

---

## STEP 3 — Approval gate, then handoff or build

Ask explicitly, as a lettered menu the user can answer in one character —
never an open question they have to compose a sentence to answer:

> ---
> **CONFIRM THIS ANALYSIS?**
> **A)** I'll build it myself → hand off a structured brief to a spec-driven tool
> **B)** You build it → re-assess the execution model, re-estimate, then execute

If your harness exposes a structured choice/confirmation UI (buttons,
multiple choice — check your adapter), use it here instead of plain text; the
letters above are the fallback every harness supports.

No confirmation, no progress. If the user still wants changes → back to
STEP 2 (remaining rounds only).

### PATH A — Handoff

This gate does **not** write its own requirements document. That problem is
solved better elsewhere. Produce a compact **handoff brief** (see
`templates/handoff-brief.md`) containing the confirmed objective, scope,
constraints, work packages, dependencies, acceptance criteria and —
crucially — the **record of the contradictory review**: which objections were
raised and how they were resolved. That record is the part no other tool
produces.

Then point the user at a spec-driven implementation tool (see
`REFERENCES.md`) and stop.

### PATH B — Assisted execution

1. **Re-assess the execution model for BUILDING**, using your adapter's
   Execution Model options. This is an independent decision from §1.5 —
   analysis is light, construction usually isn't. Justify it again.

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
    max_agents: M          # or max_passes, if your harness has no separate agents
    max_cost_budget: T     # tokens, time, or $ — whatever you're tracking
  on_cap_reached: "stop, declare partial state, report what is missing"
```

3. **Re-estimate cost** for the build. Over budget → propose a reduced
   version.

4. **Final confirmation:**
   > *Proceed with the build via `<execution model>`, with this Goal/Loop and
   > an estimated budget of ~T?*

5. **Open `run_trace.md` BEFORE the first agent/pass starts.** Not
   afterwards, not from memory. Log each task as it completes:

   `Task · Agent · Input · Output · Status · Verification · Score · Decision · Cost`

   This ordering is the whole point: a `max_cost_budget` nobody is measuring
   is a comment in a YAML block, not a cap. If you cannot observe cost during
   the run, say so up front and downgrade the cap to what it actually is — an
   intention.

6. **Execute:** initialise → run → VERIFICATION → LOOP (hard-capped) →
   SYNTHESIS. Resolve conflicts with a judge using an identical rubric when
   the divergence touches the Definition of Done; if unresolvable, declare
   the uncertainty rather than picking arbitrarily.

   **Complex builds (see Proportionality) get one mid-course checkpoint.**
   After the first work package/task completes and passes verification,
   pause before continuing to the rest:
   > *First package done and verified — continue on the same plan, or adjust
   > before I spend the rest of the budget?*
   This is not a second STEP 3 — no re-justification, no new estimate, one
   lightweight confirmation. Its only job is catching a wrong turn while a
   fraction of the budget is spent instead of all of it. Simple and Medium
   builds skip this: a single upfront gate is still enough at that scale, and
   a checkpoint there would be exactly the friction this gate is supposed to
   spend deliberately, not scatter everywhere. Log the outcome (continued
   unchanged / adjusted) in `run_trace.md` and in `CALIBRATION.md`'s
   checkpoint table — same discipline as everything else here: a mechanism
   nobody checks the value of is a superstition, not a control.

   **Stop at the edge of `non_goals`.** If useful adjacent work appears —
   especially work you already listed as out of scope — do not absorb it
   into the current run. Finish, report, and re-gate it as its own package
   with its own estimate. Work that was never costed cannot have been
   approved, and mixing it in corrupts the reconciliation in step 8: you can
   no longer tell whether the estimate was good or whether two errors
   cancelled out.

7. **Estimate reconciliation — do not skip.** Close the run with:

   | | Estimated | Actual | Δ |
   |---|---|---|---|
   | Cost | T_est | T_real | % |

   Record the cause of any significant gap. This is what turns §1.6 from a
   guess into a calibrated instrument over time, and it is the honest
   counterpart to presenting estimates at all.

8. **Append one row to `CALIBRATION.md`.** Non-negotiable, and the last thing
   you do. Log date, execution model, agent/pass count, estimate, actual,
   Δ%, and the primary cause of the gap. Recompute the correction factors
   every ~5 runs, and update the review-outcomes table **and the scope-change
   table** — log whether STEP 2 objections shrank the plan (cut a work
   package), grew it, or just rearranged it. This is a different signal from
   "materially changed": a review that only ever grows the plan back after
   cost forces a cut isn't doing the job rule 4's non-goals discipline
   depends on.

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

| Complexity | Agents/passes | Typical execution model |
|---|---|---|
| Simple | 1 | whatever your harness does by default, or just answer directly |
| Medium | 1 worker + 1 verifier + 1 synthesiser | the lightest multi-step option your harness offers |
| Complex | classifier + parallel specialists + verifiers + judge + synthesiser + loop | the most capable option your harness offers, if it offers one |

Both agent count and execution model are justified decisions. Never
defaults.

From **Medium** complexity up, the self-critique in §2.2 runs isolated from
the context that designed the plan — see the rule above. Below that, for a
single-unit Simple plan, self-critique in the same context is proportionate;
there is no second context to isolate it from.

For user-facing product-code requests, "Medium" and "Complex" start from the
five-role **Product Build roster** (§1.3.1), trimmed by justification — not
from a fresh agent count invented per request.

**Complex** is also the only tier that gets the mid-course checkpoint in
Path B step 6 — the scale where a wrong turn discovered only at the end is
expensive enough to justify one pause. Simple and Medium run straight
through after STEP 3; adding a checkpoint there would be cost with no
corresponding risk to justify it.
