# Handoff Brief — <project name>

> Produced by **Adversarial Gate** at the end of an approved analysis (Path A).
> This is not a PRD. It is the input a spec-driven tool needs, plus the one
> thing those tools don't produce: the record of the contradictory review.

Version: 1.0 · Date: <date> · Approved by: <user>

---

## 1. Confirmed objective

<Two or three lines. This is the interpretation the user explicitly approved,
not the original wording of the request.>

**Definition of Done**
- <verifiable criterion 1>
- <verifiable criterion 2>

## 2. Context and constraints

- Problem being solved:
- End users / audience:
- Constraints (time, budget, technical, regulatory):

## 3. Scope

**In scope**
- ...

**Out of scope (non-goals)**
- ...

### 3.1 Requirements

> Skip this subsection for a brief small enough that the work packages below
> say everything — don't fill it out for its own sake.

**Functional**

| ID | Requirement | Priority (MoSCoW) | Notes |
|---|---|---|---|
| RF1 | | Must / Should / Could / Won't | |

**Non-functional**

| ID | Requirement | Metric / Threshold |
|---|---|---|
| RNF1 | Performance / Security / Privacy / ... | |

## 4. Work packages

> Each package is autonomous, with its own dependencies and acceptance criteria.
> Keep them coarse — downstream tooling will decompose them further.

### WP1 — <name>
- **Objective:**
- **Contents / activities:**
- **Dependencies:** none / requires WP<n>
- **Deliverable:**
- **Acceptance criteria:**
- **Effort:** S / M / L
- **Risks:**

### WP2 — <name>
<same structure>

## 5. Dependency map

```
WP1 ──► WP2 ──► WP4
  └───► WP3 ────┘
```

## 6. Recommended sequence

<Execution order, and what can run in parallel.>

## 7. Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| | | | |

## 8. Assumptions and open questions

- **Assumptions** (adopted to proceed, unverified):
- **Open, to be decided:**

---

## 9. Record of the contradictory review

> The differentiating section. Preserve it verbatim on handoff.

**Engine used for the analysis:** <subagents / agent teams / dynamic workflow> — <one-line justification>
**Patterns applied:** <list>
**Rounds used:** <n> of 3
**Self-critique run by:** orchestrator (Simple only) / isolated adversary subagent

| # | Objection raised | Raised by | Domain (if critical) | Outcome | Effect on the plan |
|---|---|---|---|---|---|
| 1 | | user / self | — / security / irreversibility / cost / legal / scalability | defended / revised / **deferred — cap reached** | |
| 2 | | | | | |

> A row marked *deferred* is not resolved. It is the next reviewer's job to
> pick it up, not to assume it was dismissed. A row marked with a domain other
> than "—" was a handbrake, not a round — it stopped the flow until answered.

**Token estimate for the analysis (assumption, not measurement):**

| Scenario | Tokens |
|---|---|
| Typical | |
| Worst case | |

**Actual consumption:** <fill in after the run> · **Δ:** <%> · **Cause of gap:** <…>

---

## 10. Suggested next step

Feed sections 1–6 into a spec-driven implementation tool (see `REFERENCES.md`).
Carry section 9 forward unchanged: it is the audit trail of *why* the plan looks
like this.
