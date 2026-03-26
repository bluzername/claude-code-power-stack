# Findings & Decisions

## Requirements
- Make claude-code-power-stack work for small teams (2-8 people)
- Teams using Claude Code on the same codebase
- Preserve individual workflow while adding team visibility
- Keep the tool local-first - no mandatory server infrastructure

## Research Findings

### Ghost (wcatz/ghost) - Multi-User Status
- **Per-user only.** DB at `~/.local/share/ghost/ghost.db`, no user field in schema
- WAL mode enabled (5s busy timeout) - technically allows concurrent reads/writes
- `ghost serve` runs HTTP API on localhost:2187 with optional Bearer token - but NO user isolation (all token holders see all memories)
- No git-notes integration despite earlier claims
- Project scoping via `project_id` (hash of directory path) + `_global` cross-project memories
- **Verdict:** Can't share Ghost DB without forking. But Ghost's MCP tools could write to shared files.

### cc-conversation-search - Multi-User Status
- **Per-user only.** DB at `~/.conversation-search/index.db`, no user field
- WAL mode enabled (30s timeout) - more generous than Ghost
- Indexes `~/.claude/projects/*.jsonl` - always the current user's home
- `project_path` is absolute (includes username in path), preventing cross-user sharing
- **Verdict:** Can't share index. But could create a team overlay that merges exports.

### Planning Files - Already Team-Friendly
- `task_plan.md`, `findings.md`, `progress.md` live in the project directory
- Already git-tracked if the project is a git repo
- **This is the lowest-hanging fruit** - teams already share code via git, planning files ride for free
- Conflict risk: two people editing task_plan.md simultaneously
- Solution: append-only sections, or per-person progress files

### Patterns from Other Tools
- **ReviewSwarm:** JSON append-only logs + consensus reactions (confirm/dispute findings)
- **Hexswarm:** Centralized SQLite with lessons/facts/events shared across agents
- **Claude Code Team:** tmux-based, all agents share working directory
- **Oil Camp:** Yjs CRDTs for conflict-free merging
- **Key pattern:** Append-only logs avoid merge conflicts entirely

### What Already Works for Teams (No Changes Needed)
1. `.claude/CLAUDE.md` in repo - shared project rules, already git-tracked
2. Planning files in project dir - already git-trackable
3. `ccs here` - each team member searches their own sessions within the shared project
4. Ghost captures decisions per-person - individual memory is fine

### What's Missing for Teams
1. No way to see what a **teammate** decided or discovered
2. No shared findings log across team members
3. No way to search **teammates'** sessions
4. No team standup that aggregates across people

## Technical Decisions
| Decision | Rationale |
|----------|-----------|
| Git-first approach | Zero infrastructure, teams already use git, planning files are already in project dir |
| Append-only team log | Avoids merge conflicts - each person appends, never edits others' entries |
| Keep individual ccs/Ghost local | Sharing databases is fragile and neither tool supports it |
| Add team overlay, not replace individual tools | Preserves the single-user experience, team features are opt-in |

## Resources
- ReviewSwarm pattern: fozzfut/review-swarm (JSON append-only + reactions)
- Hexswarm pattern: hexdaemon/hexswarm (centralized SQLite memory)
- Ghost schema: no user field, project_id scoping, _global memories
- cc-conversation-search schema: absolute paths, no user field
