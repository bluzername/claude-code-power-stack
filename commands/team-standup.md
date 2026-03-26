## /team-standup - Team standup from the shared log

Generate a team standup summary using the shared team log and individual context.

### Steps

**1. Pull latest**

Run: `git pull --ff-only 2>/dev/null || true`

This ensures the team log is up to date.

**2. Show team activity**

Run: `ccs team`

This shows recent entries from `.team/log.jsonl` grouped by person.

**3. Check for blockers**

Run: `ccs team search blocker`

Highlight any unresolved blockers.

**4. Check individual context**

Run: `ccs ls here`

Show the current user's recent sessions in this project.

If `task_plan.md` exists, read it and note the current phase and remaining work.

**5. Present the standup**

```
Team Standup - {today's date}
================================

Team (last 24h):
- @alice [decision]: Using express-jwt middleware
- @bob [done]: Phase 2 complete - token generation
- @charlie [blocker]: CI fails on ARM builds

Blockers:
- @charlie: CI fails on ARM builds (unresolved)

Your status:
- Phase 3 in progress - auth middleware
- 2 sessions this week in this project

Suggested next:
- {most logical next step based on team log + planning files}
```

Keep it short. This is a 30-second orientation, not a report.

**6. Suggest logging**

If the user starts working, remind them to log important decisions: "When you make a key decision, say `/team-log` to share it with the team."
