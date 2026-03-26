# Claude Code Power Stack - Cheat Sheet

## Session Start
```
cd ~/my-project && claude
```
Ghost auto-loads context. Accept or adjust the suggested session name.

## Individual Commands

| What | Command |
|------|---------|
| Morning standup | `/standup` |
| End-of-session wrapup | `/wrapup` |
| Name session | `/rename-session` |
| Start planning | `/plan` |
| Search all projects | `ccs "query"` |
| Search current project | `ccs here "query"` |
| Search last N days | `ccs "query" -d 7` |
| List recent | `ccs ls` |
| List current project | `ccs ls here` |
| Resume result #1 | `ccs go 1` |
| Stats dashboard | `ccs stats` |
| Health check | `ccs doctor` |
| Quick ref in terminal | `ccs cheat` |
| Update stack | `ccs update` |
| Re-index | `ccs ix` |

## Team Commands

| What | Command |
|------|---------|
| Init team mode | `ccs team init` |
| Team standup (terminal) | `ccs team standup` |
| Team standup (Claude) | `/team-standup` |
| Log decision | `ccs team log d "msg"` |
| Log finding | `ccs team log f "msg"` |
| Log blocker | `ccs team log b "msg"` |
| Log completed | `ccs team log done "msg"` |
| Log handoff | `ccs team log h "msg"` |
| Show team activity | `ccs team` |
| Search team log | `ccs team search "query"` |
| Commit + push log | `ccs team sync` |

## Session Naming

```
{project}-{type}-{descriptor}
```

**Types:** `feat` `fix` `debug` `explore` `review` `plan` `research` `comms`

**Examples:** `api-feat-auth-flow` | `mobile-fix-crash` | `infra-plan-k8s`

## Planning Files (created by /plan)

| File | What | When to update |
|------|------|----------------|
| `task_plan.md` | Phases, decisions, errors | After each phase |
| `findings.md` | Research, discoveries | After every 2 searches |
| `progress.md` | Session log | Throughout session |

## The 2-Action Rule

After every **2** searches / file reads / web lookups:
**immediately save findings to findings.md**

Context window = RAM (volatile). Planning files = disk (persistent).

## Resuming Work

```bash
ccs "auth migration"        # numbered results
ccs go 1                    # resume #1

# Or start fresh
cd ~/my-project && claude   # Ghost + planning files restore context
```

## Decision Tree

```
Start of day?  --> ccs team standup (or /standup)
Complex task?  --> /plan
Simple task?   --> just do it (Ghost captures silently)
Done for now?  --> /wrapup (summarize + log for team)
Find old work? --> ccs "topic" then ccs go 1
Team decision? --> ccs team log d "msg" then ccs team sync
Back after days? --> planning files = instant recovery
```

## Error Protocol (3 strikes)

```
Strike 1: Diagnose and fix
Strike 2: Try different approach (never repeat same action)
Strike 3: Rethink assumptions, search for solutions
After 3:  Escalate to user
```

## The 5-Question Reboot Test

| Question | Source |
|----------|--------|
| Where am I? | Current phase in task_plan.md |
| Where am I going? | Remaining phases |
| What's the goal? | Goal statement in task_plan.md |
| What have I learned? | findings.md |
| What have I done? | progress.md |

---
*Claude Code Power Stack v1.4.0 by [@bluzername](https://github.com/bluzername)*
