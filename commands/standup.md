## /standup - Morning standup with yourself

Generate a quick personal standup summary using all Power Stack tools. Run this at the start of your day to remember where you left off.

### Steps

**1. Recent sessions**

Run this command and read the output:
```bash
ccs ls 2
```
List sessions from the last 2 days. Note the projects and session names.

**2. Check for active planning files**

Look for planning files in the current project directory:
- If `task_plan.md` exists, read it and note the current phase and remaining work
- If `progress.md` exists, read the last session entry
- If `findings.md` exists, scan for unresolved questions

**3. Ghost context**

If Ghost MCP tools are available, use `ghost_project_context` to load relevant context for the current project. This surfaces decisions, conventions, and gotchas Ghost has captured.

**4. Generate the standup**

Present a concise summary in this format:

```
Standup - {today's date}
========================

Yesterday:
- {project}: {what was done, from planning files or session history}
- {project}: {what was done}

In progress:
- {project}: Phase {N} of task_plan.md - {description}
- {any unresolved items from findings.md}

Suggested next:
- {most logical next step based on planning files and context}
```

Keep it short - 5-10 lines max. This is a quick orientation, not a report.

**5. Suggest session name**

If the user seems ready to start working, suggest a session name using the `/rename-session` convention.
