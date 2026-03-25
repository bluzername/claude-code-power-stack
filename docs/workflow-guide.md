# Workflow Guide

A detailed walkthrough of how the Claude Code Power Stack fits into your daily development workflow.

## The Four Layers

Your stack has four layers of memory and context:

| Layer | Role | Activation |
|-------|------|-----------|
| **Ghost** | Auto-captures decisions, mistakes, patterns per project | Passive (MCP + SessionStart hook) |
| **cc-conversation-search** | Finds old sessions across all projects | Active (you search when needed) |
| **/rename-session** | Makes sessions findable by name | Active (you name at session start) |
| **/plan** | Persistent working memory for complex tasks | Active (you invoke for multi-step work) |

Ghost and cc-conversation-search solve the **between-sessions** problem.
Planning-with-files solves the **within-session** problem.

## Workflow Examples

### Example 1: New feature development

```
cd ~/projects/my-api
claude

> "Add JWT authentication to the API"
Claude: Want me to name this session? I'd suggest: api-feat-jwt-auth
> "yes, and /plan"

--> Claude creates task_plan.md, findings.md, progress.md
--> Researches JWT libraries, logs findings
--> Implements phase by phase
--> Ghost silently records decisions along the way
```

### Example 2: Quick bug fix

```
cd ~/projects/my-api
claude

> "Fix the 500 error on /users endpoint"
Claude: Want me to name this? api-fix-users-500
> "sure"

--> No /plan needed for a focused fix
--> Ghost captures what the bug was and how it was fixed
--> Session name makes it findable later
```

### Example 3: Resuming interrupted work

```bash
# You were working on something last week but can't remember which session
cc-conversation-search search "database migration"
# Shows: api-feat-db-migration (id: abc123...)

# Option A: Resume exact session
claude --resume abc123

# Option B: Start fresh (Ghost + planning files provide context)
cd ~/projects/my-api
claude
> "Continue the database migration work"
# Ghost loads project context
# If /plan was used, Claude reads task_plan.md and picks up at the right phase
```

### Example 4: Cross-project research

```
claude

> "What authentication approach have I used across my projects?"
# Ghost has per-project decision records
# cc-conversation-search can find relevant sessions:
#   cc-conversation-search search "authentication"
# Claude synthesizes across projects
```

## Tips

### Name sessions early
Do it in the first message. `api-feat-jwt-auth` is findable months later. `help me with this code` is not.

### Use /plan for anything over 10 minutes
The overhead of creating three files is 30 seconds. The payoff is: you never lose context on long tasks, and you can resume after any interruption.

### Trust Ghost for decisions
You don't need to manually note "we chose library X because Y." Ghost captures this automatically. Focus your energy on the planning files for structured work.

### Re-index periodically
```bash
cc-conversation-search index --all
```
Run this weekly or when you notice search results are stale.

### The planning files are yours
They live in your project directory, not in Claude's config. You can read them yourself, share them with teammates, or use them as documentation for what was done and why.
