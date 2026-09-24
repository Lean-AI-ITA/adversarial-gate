# References and landscape

This skill deliberately **does not duplicate** the documentation of the
execution engines. Engine mechanics change; a skill that restates them drifts
out of date and starts teaching people things that are no longer true.

## Official execution-model documentation

Read these for how each harness actually runs work — who holds the plan,
where intermediate results live, whether subagents exist at all. This is
exactly the kind of mechanics `core/GATE.md` refuses to restate, because it
goes stale the moment a harness ships a change:

- Claude Code (subagents, agent teams, dynamic workflows) — <https://docs.claude.com/en/docs/claude-code>
- Cursor (rules, Background Agents) — <https://cursor.com/docs>
- GitHub Copilot (prompt files, coding agent) — <https://docs.github.com/copilot>
- Codex CLI (AGENTS.md, custom prompts) — <https://developers.openai.com/codex>
- OpenCode (agents, subagents, commands) — <https://opencode.ai/docs>
- Aider (conventions files, config) — <https://aider.chat/docs>

Two things worth knowing about the Claude Code engines specifically, since
that's the adapter with the most native isolation to offer:

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

## Nearby: other adversarial-gate-style skills

A follow-up search turned up several projects working similar territory. None
do what this skill does end to end, but two of them changed this design —
credited here rather than silently absorbed:

| Project | What it does | What's different here |
|---|---|---|
| **carrilloapps/skills — Devil's Advocate** | A pre-action gate across 40+ agents and ~12 domains (security, architecture, compliance...), with a proceed/revise/cancel decision and a "handbrake" halt on critical findings | This gate costs the plan explicitly and runs a round-capped *dialogue with the human* rather than a framework sweep, across six harness adapters rather than a plugin-per-tool. **Borrowed:** the handbrake — see the critical-domain rule in `core/GATE.md` §Absolute rules |
| **Dzazaleo/adversarial-review-skills** | Cross-model review of *finished* code; a permanent ledger rules truthful/false per finding, and a deferred finding must produce a real backlog file, not a promise | This skill gates the plan *before* a token is spent, not the code after. **Borrowed:** the discipline that a deferred objection needs a real artefact — see the "deferred, cap reached" rows in `templates/handoff-brief.md` and `templates/run-trace.md` |
| lemon03390, alirezarezvani, poteto, aojdevstudio — assorted `adversarial-review` skills | Also post-work code review; one worker + one critic pattern | Same category as above: reviews output, not a plan. No pre-spawn gate, no token estimate, no calibration ledger |

None of these were the source of the original design — the gate, the token
estimate and the calibration ledger predate this search. What changed after
reading them: the handbrake rule and the deferred-objection bookkeeping above.

## Epistemic status of this document

- **Evidence:** the existence and stated purpose of the projects listed above.
- **Inference:** that their scope does not include the pre-execution
  contradictory review.
- **Assumption:** that the landscape has not shifted since the survey. Verify
  before relying on the comparison.
