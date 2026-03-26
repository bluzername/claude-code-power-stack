## /wrapup - End-of-session summary and team log

Summarize what was accomplished in this session and offer to log key items for the team.

### Steps

**1. Summarize the session**

Review the current conversation and identify:
- Decisions made
- Things completed
- Unresolved issues or blockers
- Findings worth sharing

**2. Update planning files if active**

If `task_plan.md` exists in the current directory:
- Mark completed phases as `complete`
- Update `progress.md` with a session summary
- Note any new errors or decisions in `task_plan.md`

**3. Present the wrapup**

```
Wrapup - {today's date}
========================

Done:
- {what was completed}

Decisions:
- {key decisions made and why}

Open:
- {unresolved items, things to pick up next}
```

Keep it concise - 5-10 lines.

**4. Offer to log for the team**

If `.team/log.jsonl` exists (team mode is active), ask:

> "Want me to log any of these for the team? I'd suggest:
> - [done] {completed item}
> - [decision] {key decision}
> - [blocker] {if any}"

If the user confirms, run `ccs team log` for each entry. Then remind them to run `ccs team sync` to share.

**5. Suggest session name**

If the session hasn't been named yet, suggest a name using the `/rename-session` convention so it's findable later.
