# Run Trace — <project name>

> Produced by **Adversarial Gate** during Path B (assisted execution).
> Mandatory. A run without a trace cannot be reconciled, and an estimate that is
> never reconciled is theatre.

Run ID: <id> · Date: <date> · Engine: <subagents / agent teams / dynamic workflow>

---

## 0. Deferred objections carried from the review (if any)

> Only non-critical objections can reach this state — a critical-domain one is
> a handbrake and must be answered before STEP 3, never deferred. Leave this
> table empty if the review closed clean.

| # | Objection | Domain | Raised by | Why still open |
|---|---|---|---|---|

## 1. Goal & Loop (as approved)

```yaml
goal:
  deliverable: <concrete artefact>
  definition_of_done:
    - <verifiable criterion 1>
  non_goals:
    - <out of scope>

loop:
  stop_conditions:
    - <soft condition>
  hard_caps:
    max_iterations: N
    max_agents: M
    max_token_budget: T
  on_cap_reached: "stop, declare partial state, report what is missing"
```

## 1.1 Complex-build checkpoint (Complex only — delete this section otherwise)

After the first work package/task, verified, before spending the rest of
the budget:

- **Outcome:** continued unchanged / adjusted
- **If adjusted, what changed:**

## 2. Execution log

| Task | Agent | Input | Output | Status | Verification | Score | Decision | Tokens |
|---|---|---|---|---|---|---|---|---|
| T1 | A1 | | | done / partial / failed | rubric ref | /10 | accepted / re-run | |
| T2 | A2 | | | | | | | |

## 3. Conflicts and how they were resolved

| Conflict | Agents involved | Touches DoD? | Judge rubric | Resolution |
|---|---|---|---|---|
| | | yes / no | | resolved / **declared uncertain** |

> If a divergence touching the Definition of Done could not be resolved, it must
> appear here as *declared uncertain* — never silently picked.

## 4. Loop termination

- Iterations used: <n> / <max>
- Terminated by: soft stop condition / **hard cap**
- If hard cap: partial state declared, missing work listed below
  - <missing item>

## 5. Estimate reconciliation

| | Estimated | Actual | Δ |
|---|---|---|---|
| Tokens | T_est | T_real | ±% |
| Agents spawned | | | |
| Iterations | | | |

**Cause of the gap:** <e.g. verification re-runs underestimated; input context
larger than assumed; loop hit cap>

**Calibration note for next time:** <what to adjust in the STEP 1.6 estimate>

## 6. Epistemic summary of the deliverable

| Label | Items |
|---|---|
| Evidence | |
| Inference | |
| Assumption | |
| Uncertainty | |
