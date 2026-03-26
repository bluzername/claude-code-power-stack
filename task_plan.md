# Task Plan: Multi-User Power Stack for Small Teams

## Goal
Design how claude-code-power-stack can support small teams (2-8 people) working together with Claude Code - shared memory, shared session search, shared planning context - without changing the core purpose of the repo.

## Current Phase
Phase 3

## Phases

### Phase 1: Requirements & Discovery
- [ ] Understand what "multi-user" means for each tool in the stack
- [ ] Research how Ghost, cc-conversation-search, and /plan files could be shared
- [ ] Identify what's already team-friendly vs what needs new work
- [ ] Document findings in findings.md
- **Status:** complete

### Phase 2: Architecture Design
- [x] Design shared memory layer (Ghost stays local, team log via git)
- [x] Design shared session search (ccs team reads .team/log.jsonl)
- [x] Design shared planning files (append-only JSONL, git-tracked)
- [x] Define what stays local vs what's shared
- [x] Map out the user experience for a team member
- **Status:** complete

### Phase 3: Implementation
- [x] Add `ccs team` subcommand (log, search, init, show)
- [x] Create `/team-log` command
- [x] Create `/team-standup` command
- [x] Update completions (zsh + bash), help, cheat card
- [x] Update README with Team Mode section + TOC
- [x] Test end-to-end (init, log 4 types, show, search)
- **Status:** complete

## Key Questions
1. Should team members share Ghost memory or just see each other's decisions?
2. How do planning files work when 2 people work on the same project?
3. Should ccs search across teammates' sessions or only your own?
4. What's the simplest approach that delivers 80% of the value?
5. Does this require a server/backend or can it stay fully local?

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| Git-first, no server | Teams already share via git. Zero infrastructure. |
| Append-only team log | Avoids merge conflicts entirely. Each person appends, never edits others' lines. |
| Keep Ghost/ccs local per-person | Neither tool supports multi-user. Sharing DBs is fragile. |
| Team features are opt-in overlay | Don't break the single-user experience. Team = extra files + commands. |
| Planning files become team artifacts | They're already in the project dir. Just need conventions for multi-person use. |
| `.team/` directory in project root | Clean separation from individual planning files |
| Auto-detect user from git config | Magical, no setup needed, already available in any git repo |
| /team-standup separate from /standup | Don't break individual workflow, team is opt-in |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
