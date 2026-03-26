## /team-log - Log a decision, finding, or blocker for your team

Append an entry to the team's shared log (`.team/log.jsonl` in the project directory).

### Steps

**1. Check team mode is initialized**

Run: `ls .team/log.jsonl`

If it doesn't exist, run: `ccs team init`

**2. Determine the entry type from the user's message**

| Type | When to use |
|------|-------------|
| `decision` | A technical or design choice was made |
| `finding` | Something was discovered during research or debugging |
| `blocker` | Something is blocking progress |
| `done` | A phase, feature, or task was completed |
| `handoff` | Work is being passed to a teammate |

Default to `decision` if unclear.

**3. Log it**

Run this command, replacing TYPE and MESSAGE:
```bash
ccs team log TYPE "MESSAGE"
```

The entry automatically includes your name (from `git config user.name`) and timestamp.

**4. Remind about git**

After logging, remind the user: "Don't forget to commit and push `.team/log.jsonl` so your team sees this."
