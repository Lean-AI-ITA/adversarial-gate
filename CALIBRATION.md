# Calibration Ledger

> Your estimates get better only if you check them. This file is where the skill
> remembers how wrong it was last time.

Every completed Path B run appends one row here. Before producing a new token
estimate, the skill **reads this file first** and adjusts. That is the whole
mechanism: an estimator with no feedback loop is a random number with a table
around it.

This file is **yours**, local, and grows with your work. It is the reason
uninstalling stops being free after the fifth run.

---

## Ledger

| Date | Run | Engine | Agents | Est. tokens | Actual | Δ% | Primary cause of gap |
|---|---|---|---|---|---|---|---|
| 2026-09-24 | Lotto 2 — hybrid perception, voice input, skill memory (19 min) | subagents | 3 | 240–280k typical · 450k cap | 249.9k | −4% vs midpoint, inside band | Estimate accurate, but see note: run also performed unplanned Lotto 3 work, so accuracy may reflect compensating errors rather than a calibrated model |

> Keep rows even when the estimate was good. Systematic accuracy is a signal too.

---

## Derived correction factors

Recompute after every ~5 runs. Apply these to raw estimates in STEP 1.6.

| Engine | Runs | Median Δ% | Correction factor | Confidence |
|---|---|---|---|---|
| subagents | 1 | −4% | 1.00 | none — 1 run, 3 needed before applying a factor |
| agent teams | 0 | — | 1.00 | none — no data yet |
| dynamic workflow | 0 | — | 1.00 | none — no data yet |

**How to apply:** `corrected = raw × factor`. Below 3 runs for an engine, do not
apply a factor — state that the estimate is uncalibrated for that engine and say
so out loud in the proposal. A confident number built on two data points is
worse than an honest shrug.

---

## Recurring causes of underestimation

Log patterns here as they emerge. These become checklist items for future
estimates.

| Cause | Times seen | Typical impact | Mitigation now applied |
|---|---|---|---|
| Verification re-runs not counted | 0 | — | — |
| Input context larger than assumed | 0 | — | — |
| Loop reached hard cap | 0 | — | — |
| Scope grew during execution | 1 | Not isolable — work past the declared non-goals was mixed into the same run | Declared non-goals now require a fresh gate; a blanket "go all the way" does not authorise a scope not yet costed |
| Run not instrumented from the start | 1 | Actual usage had to be recovered after the fact; the 450k hard cap was unenforceable during the run | Open `run_trace.md` **before** execution and log tokens per task as they accrue, not retrospectively |

---

## Review outcomes

Tracks whether the adversarial review is earning its keep. If objections almost
never change the plan, the review is theatre and should be relaxed. If they
almost always do, the analysis stage is too weak.

| Runs reviewed | Rounds used (avg) | Plans materially changed | Objections upheld by the skill |
|---|---|---|---|
| 1 | 0 | 0 | 0 |

**Note on run 1:** the review was skipped — the plan was approved in one pass with
a blanket "go all the way". That is the failure mode this skill exists to catch,
observed on the skill's own project. A gate that can be dissolved by a single
up-front authorisation is not a gate.

**Healthy range:** roughly a third to two thirds of plans change. Outside that
band, something is miscalibrated — and it isn't the user.

---

## Scope changes during review

A different signal from "materially changed" above — that table says *if*
the plan moved, this one says *which direction*. A review that only ever
grows the plan back after cost forces a cut isn't earning its keep either;
the non-goals discipline in Path B step 6 depends on cuts actually sticking.

| Runs reviewed | Scope shrank (a work package cut) | Scope grew | Rearranged only, same scope |
|---|---|---|---|
| 0 | — | — | — |

No data yet — this table starts empty on purpose. Populate it from real
Path B step 8 runs only; a plausible-looking number here that didn't come
from an actual review is exactly the "confident guess on two data points"
this whole file exists to avoid.
