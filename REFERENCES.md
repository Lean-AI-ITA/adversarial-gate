# References and landscape

This skill deliberately **does not duplicate** the documentation of the
execution engines. Engine mechanics change; a skill that restates them drifts
out of date and starts teaching people things that are no longer true.

## Official engine documentation

Read these for how subagents, agent teams and dynamic workflows actually work —
who holds the plan, where intermediate results live, and how they scale:

- Anthropic — Claude Code documentation (subagents, agent teams, dynamic workflows)
  <https://docs.claude.com/en/docs/claude-code>

Two things worth knowing before choosing an engine:

- **Agent teams are experimental** and disabled by default. Their tooling has
  already changed once (team lifecycle tools removed, `team_name` deprecated).
  Warn the user when selecting this engine.
- **Dynamic workflows are token-hungry.** They consume substantially more than a
  normal session. Start narrow, then widen.

## Adjacent projects — use these, don't compete with them

This skill covers the planning gate only. For everything downstream:

| Project | What it does | Relationship |
|---|---|---|
| **GitHub Spec Kit** | Spec-driven development: constitution → spec → plan → tasks | Path A hands off here |
| **Task Master** | Parses a PRD into a tracked task graph | Path A hands off here |
| **Shannon** | Production runtime with token budget control and human approval workflows | Infra-level counterpart; this skill is conversational |
| **ai-prd-creator** | Structured PRD generation for multi-agent systems | Replaces the PRD this skill deliberately doesn't write |
| **Don Cheli SDD** | Large spec-driven command/skill suite | Broader lifecycle |
| **awesome-claude-code** | Community catalogue of skills and commands | Where to look before building anything |

The Claude Code skill ecosystem is large — tens of thousands of discoverable
`SKILL.md` files across thousands of repositories. Search it before you build.

## What is *not* covered elsewhere

As of the survey behind this repository, no examined project implements a
**structured, round-capped adversarial review between the system and the human,
conducted before execution and recorded as an artefact.** That gap is the reason
this skill exists. If you find prior art, open an issue — the honest outcome of
a duplicate finding is a link, not a competing repo.

## Epistemic status of this document

- **Evidence:** the existence and stated purpose of the projects listed above.
- **Inference:** that their scope does not include the pre-execution
  contradictory review.
- **Assumption:** that the landscape has not shifted since the survey. Verify
  before relying on the comparison.
