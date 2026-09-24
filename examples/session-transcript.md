# Example session — the gate in action

An annotated transcript, running the Claude Code adapter (its engine
vocabulary — subagents — shows up below). The logic is the same on every
other adapter; only the engine names would change. Two moments worth
watching: the **handbrake**, right after STEP 2 opens, which stops on a
minors'-data question before any round starts counting — and **round 2**,
where a single user objection changes the architecture *before* any token is
spent building.

> Annotations in blockquotes are commentary, not part of the session.

---

**User:** I want to build a management system for a football club.

**Adversarial Gate:** What do you want to achieve? Describe the goal freely.

> The skill never asks "which agent should I use?". Engine selection is its job,
> not yours.

**User:** Rosters, match scheduling, attendance, and a parent-facing view for
youth teams. Small club, no budget for a SaaS subscription.

---

## STEP 1 → STEP 2 — Proposal

**Adversarial Gate:**

**Interpreted objective.** A self-hosted management system covering roster,
scheduling, attendance and a read-only parent portal, for a small club with no
recurring budget.

**Definition of Done for the analysis**
- Functional scope split into work packages with dependencies
- A build-vs-assemble recommendation with reasoning
- Explicit constraints on hosting and data protection for minors' data

**Strategy.** The hard part is not the code, it's scope discipline: club
management systems fail by growing features nobody uses. Fan-out on the domain,
then adversarial verification against the "no budget" constraint.

**Agents**

| ID | Agent | Role | Activity | Model |
|---|---|---|---|---|
| A1 | Domain-Mapper | Analyst | Decompose the four functional areas | mid |
| A2 | Constraint-Checker | Verifier | Test each feature against cost/hosting/privacy constraints — isolated context | mid |
| A3 | Synthesiser | Synthesiser | Work packages, dependencies, recommendation | top |

**Workflow**

```
Request ──► A1 Domain-Mapper ──► A2 Constraint-Checker (isolated) ──► A3 Synthesiser
```

**Patterns:** 02 Fan-out-and-Synthesize (four independent domains);
03 Adversarial Verification (the budget constraint is exactly what optimistic
analysis quietly ignores). *Not used:* Tournament, Loop Until Done — the work is
bounded and there are no rival solutions to rank.

**Engine for the analysis: subagents.** Three agents, two turns, one isolated
verification point. *Agent teams* rejected: no continuous peer dialogue needed,
and it's experimental. *Dynamic workflows* rejected: no deterministic loop, and
intermediate results won't saturate the context.

**Token estimate — ASSUMPTION, not a measurement**

| Step | Typical | Worst case |
|---|---|---|
| A1 | ~9k | ~14k |
| A2 | ~7k | ~12k |
| A3 | ~11k | ~17k |
| **Total** | **~27k** | **~43k** |

---

## STEP 2 — Self-critique, before the floor opens

Two weaknesses I'll raise against myself, checklist first:

1. A2 checks features against constraints, but I never asked what you can
   actually host. Not a critical-domain point — I'll fold it into the general
   question below.
2. I'm **assuming** parent-facing access to minors' data is in scope. That
   *is* a critical-domain point — sensitive data, and a legal surface, not
   just a feature.

> ---
> **HANDBRAKE — before anything else**
>
> Point 2 touches minors' data and legal exposure (rule 6). I'm not folding
> it into a round. **Does parent access to children's data belong in scope at
> all, or should this stay coach-only?** Everything else waits on this
> answer.

**User:** Yes — parents need access, that's the whole point, coaches are
drowning in WhatsApp messages.

**Adversarial Gate:** Understood — parent portal is confirmed in scope, and
I'm adding data-minimisation as an explicit acceptance criterion rather than
a note, since we've now committed to the surface that made it necessary.
Handbrake cleared. Opening the general floor now.

---

## STEP 2 — Contradictory review, round 1

**Adversarial Gate:** Do you have objections? Challenge my choices: agents,
patterns, engine, cost.

One more thing I'll raise against myself, now that it's a regular round: A2
checks features against constraints, but I never asked what you can actually
host. If the answer is "nothing, I have a laptop", half the architecture is
wrong.

> The gate is required to surface its own weakest non-critical assumption
> each round too — the handbrake doesn't excuse the rest of the checklist.

**User:** There's a shared hosting account already.

**Adversarial Gate:** Good — no change needed there.

---

## STEP 2 — Contradictory review, round 2

**User:** I don't think you need three agents for this. It's a CRUD app.

**Adversarial Gate:** Partly agreed, and partly not.

You're right that A1 is oversized — domain decomposition for four well-understood
entities doesn't need a dedicated pass. I'm cutting it.

I'm keeping A2, and defending it. It is the only agent with an isolated context,
and its job is to contradict the plan against the constraints you just gave me.
Remove it and the analysis marks its own homework — which is the specific failure
this whole skill exists to prevent. Cutting it saves roughly 7k tokens and buys
an analysis I wouldn't trust.

**Revised: 2 agents, ~18k typical / ~29k worst case.**

> Note what did *not* happen: it didn't cave to be agreeable, and it didn't dig
> in to be right. One objection accepted, one refused with a reason.

**User:** Fair.

---

## STEP 3 — Approval gate

**Adversarial Gate:**

> ---
> **CONFIRM THIS ANALYSIS?**
> **A)** I'll build it myself → hand off a structured brief
> **B)** You build it → re-assess the engine, re-estimate cost, confirm again, execute with traceability

> Two rounds used, one remaining. Without an explicit answer here, nothing
> proceeds — "sounds good" about something else does not count as approval.
> Note the format too: a rule and a bold header, not another paragraph — the
> point is that this reads as a stop sign in scrollback, not something to
> skim past (§2.1.1).

**User:** A.

**Adversarial Gate:** Handoff brief written to `handoff-brief-football-club.md`,
including the record of this review: the handbrake on minors' data that
promoted the parent portal to a primary driver, and the A1 cut you argued
for. Feed sections 1–6 into a spec-driven tool; carry section 9 forward
unchanged — it's the audit trail of why the plan looks like this.

Stopping here. No code, no scaffolding, no execution.

---

## What this example demonstrates

| Property | Where |
|---|---|
| Asks before designing | opening exchange |
| Justifies the engine, *including why not the others* | STEP 1 |
| Labels the estimate as an assumption | token table |
| Contests its own proposal, checklist first | self-critique, before round 1 |
| Handbrake fires before the floor opens, doesn't spend a round | minors' data exchange |
| Revises when wrong, defends when right | rounds 1 and 2 |
| Refuses to advance without explicit approval | STEP 3 |
| Hands off instead of writing its own PRD | Path A |
