# Workflow Guide

How the Claude Code Power Stack fits into your daily development workflow.

## The Stack at a Glance

| Layer | Role | Activation |
|-------|------|-----------|
| **Ghost** | Auto-captures decisions, mistakes, patterns | Passive (MCP + SessionStart hook) |
| **ccs** | Search, list, resume, stats, health checks | Active (you run commands) |
| **/rename-session** | Makes sessions findable by name | Active (at session start) |
| **/plan** | Persistent working memory for complex tasks | Active (for multi-step work) |
| **/standup** | Morning summary of yesterday + active plans | Active (start of day) |

Ghost and ccs solve the **between-sessions** problem.
/plan solves the **within-session** problem.
/standup ties them all together.

## Daily Workflow

### Morning

```bash
cd ~/projects/my-api
claude
```
> You: "/standup"

Claude checks your recent sessions (via `ccs ls`), reads any active planning files, loads Ghost context, and gives you a summary:

```
Standup - 2025-03-26
========================
Yesterday:
- api: Implemented JWT token generation (Phase 2 complete)

In progress:
- api: Phase 3 of task_plan.md - Add auth middleware

Suggested next:
- Continue Phase 3, then integration tests
```

### Starting work

Claude suggests a session name. Accept or adjust:
> Claude: Want me to name this session? I'd suggest: `api-feat-jwt-middleware`
> You: "yes"

For complex tasks (3+ steps), activate planning:
> You: "/plan"

This creates `task_plan.md`, `findings.md`, `progress.md` in your project. Claude works phase by phase and updates these as it goes.

### During work

Nothing to do. Ghost silently captures decisions. If /plan is active, Claude updates the planning files as phases complete.

**One habit to build:** if you're doing research (reading docs, searching code, exploring options), tell Claude to update `findings.md` after every 2 lookups. Context window = RAM. Planning files = disk.

### End of session

Before closing, say `/wrapup`. Claude will:
1. Summarize what was done, decisions made, and open items
2. Update planning files (mark phases complete, log progress)
3. Offer to log key items for the team (if team mode is active)
4. Suggest a session name if you haven't set one

Or just close the terminal - Ghost already has your decisions and planning files have your progress.

## Searching and Resuming

### Find sessions

```bash
ccs "jwt auth"              # Search all projects
ccs here "auth"             # Search current project only
ccs "auth" -d 7             # Last 7 days
ccs "auth" --since 2025-03  # Since a date
```

Results are numbered:
```
[1] 2025-03-25 14:00  ~/projects/api  (198 msgs)
    Add JWT authentication to the API...
[2] 2025-03-23 10:30  ~/projects/api  (45 msgs)
    Research JWT library options...
2 sessions. Resume with: ccs go 1
```

### Resume

```bash
ccs go 1                    # Resume result #1 (works after search or ls)
ccs go a1b2c3d4-...         # Resume by full session ID
```

### List recent sessions

```bash
ccs ls                      # Last 7 days (numbered, with previews)
ccs ls here                 # Current project only
ccs ls 30                   # Last 30 days
ccs ls here 30              # Current project, last 30 days
```

## Monitoring

### Usage stats

```bash
ccs stats
```
Shows total sessions, messages, projects tracked, activity this week, and a bar chart of most active projects.

### Health check

```bash
ccs doctor
```
Checks Ghost binary, MCP registration, Ollama server, embedding model, cc-conversation-search, index freshness, and ccs shortcut. Shows OK/FAIL with fix commands for each.

### Quick reference

```bash
ccs cheat
```
Color-coded cheat sheet in your terminal - every command organized by category. No need to open GitHub or the PDF.

## Workflow Examples

### New feature

```
cd ~/projects/api && claude

> "Add rate limiting to the API"
> Claude suggests: api-feat-rate-limiting
> "yes, and /plan"

Claude creates planning files, researches options,
implements phase by phase. Ghost captures decisions.
You close the terminal when done.
```

### Quick bug fix

```
cd ~/projects/api && claude

> "Fix the 500 error on /users endpoint"
> Claude suggests: api-fix-users-500
> "sure"

No /plan needed. Ghost captures the fix.
Session name makes it findable.
```

### Resuming after time away

```bash
# What was I doing?
ccs here "migration"
# [1] 2025-03-20  ~/projects/api  (312 msgs)
#     Database migration for user table...

ccs go 1
# Claude picks up at Phase 3 - Ghost loads decisions,
# task_plan.md shows remaining phases
```

### Cross-project research

```bash
# What auth approaches have I used?
ccs "authentication"
# Shows sessions from api, mobile, infra projects
# Ghost has per-project decision records
# Claude synthesizes across all of them
```

## Tips

**Name sessions immediately.** `api-feat-jwt-auth` is findable months later. `help me with this code` is not.

**Use /plan for anything over 10 minutes.** The overhead is 30 seconds. The payoff: you never lose context on long tasks.

**Trust Ghost for decisions.** Don't manually note "we chose library X because Y." Ghost captures this. Save your energy for planning files.

**Run `ccs doctor` when something feels off.** It checks everything in 2 seconds.

**Run `ccs ix` weekly.** The index auto-updates before searches, but a full re-index catches any gaps.

**Planning files are yours.** They live in your project directory. Read them yourself, share with teammates, or use as documentation.

## Updating

```bash
cd ~/.claude-power-stack && ./update.sh
```

Or re-run the one-liner:
```bash
curl -fsSL https://raw.githubusercontent.com/bluzername/claude-code-power-stack/main/setup.sh | bash
```

Both pull the latest repo, upgrade Ghost + cc-conversation-search, and refresh all commands/skills/completions. Shows a changelog of what's new.
