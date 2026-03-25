# Claude Code Power Stack - Cheat Sheet

## Session Start
```
cd ~/my-project && claude
```
Ghost auto-loads context. Accept or adjust the suggested session name.

## Commands

| What | Command |
|------|---------|
| Name session | `/rename-session` |
| Start planning | `/plan` |
| Search sessions | `ccs "query"` |
| Search last N days | `ccs "query" -d 7` |
| Search since date | `ccs "query" --since 2025-03-01` |
| List recent | `ccs ls` |
| List last 30 days | `ccs ls 30` |
| Resume result #1 | `ccs go 1` |
| Resume by ID | `ccs go <session-id>` |
| Stats dashboard | `ccs stats` |
| Health check | `ccs doctor` |
| Re-index | `ccs ix` |

## Session Naming Convention

```
{project}-{type}-{descriptor}
```

**Types:** `feat` `fix` `debug` `explore` `review` `plan` `research` `comms`

**Examples:** `api-feat-auth-flow` | `mobile-fix-crash` | `infra-plan-k8s`

## When to Use /plan

| Use /plan | Skip /plan |
|-----------|------------|
| 3+ step tasks | Quick questions |
| Research then build | Single file edits |
| Long sessions (50+ calls) | Simple known fixes |
| Multi-session work | Running /recap, /email |

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
# Find session (results are numbered)
ccs "auth migration"

# Resume result #1 - no UUID copying
ccs go 1

# Or start fresh (Ghost + planning files restore context)
cd ~/my-project && claude
```

## Decision Tree

```
Complex task?  --> /plan
Simple task?   --> just do it (Ghost captures silently)
Find old work? --> ccs "topic"
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
*Claude Code Power Stack by [@bluzername](https://github.com/bluzername)*
