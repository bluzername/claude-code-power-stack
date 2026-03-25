# Claude Code Power Stack

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/bluzername/claude-code-power-stack/pulls)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-D97757.svg)](https://docs.anthropic.com/en/docs/claude-code)

**Stop losing context. Start every session where you left off.**

A curated toolkit that gives [Claude Code](https://docs.anthropic.com/en/docs/claude-code) persistent memory, cross-project search, structured planning, and session management - so you never repeat work across projects.

```bash
git clone https://github.com/bluzername/claude-code-power-stack.git && cd claude-code-power-stack && ./install.sh
```

---

## What's in the Stack

| Tool | What it solves | How it works |
|------|---------------|-------------|
| **[Ghost](https://github.com/wcatz/ghost)** | "I already figured this out last week" | MCP server that auto-captures decisions, mistakes, and patterns per project |
| **[cc-conversation-search](https://github.com/akatz-ai/cc-conversation-search)** | "Where was I working on X?" | Cross-project semantic search across all Claude Code conversations |
| **Session naming** | "Which session was the auth refactor?" | `/rename-session` command with structured naming convention |
| **Planning-with-files** | "I lost track halfway through" | File-based working memory for complex, multi-step tasks |

### The problem this solves

```
Without                              With Power Stack
---------                            ----------------
"What did I decide last week?"       Ghost auto-captured it
"Which session had the auth work?"   ccs "auth" finds it in seconds
"Where was I in this feature?"       task_plan.md says Phase 3, next: tests
"I need to re-research everything"   findings.md has all your notes
```

Ghost and cc-conversation-search handle the **between-sessions** problem.
Planning-with-files handles the **within-session** problem (long tasks that exhaust context).

---

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- [Go 1.21+](https://go.dev/dl/) (for Ghost)
- [uv](https://github.com/astral-sh/uv) (for cc-conversation-search) - or pip

<details>
<summary><b>Don't have Go or uv?</b> (click to expand)</summary>

```bash
# macOS (Homebrew)
brew install go
brew install uv

# Or skip Go entirely - install Ghost via Homebrew instead:
brew install wcatz/tap/ghost

# uv without Homebrew:
curl -LsSf https://astral.sh/uv/install.sh | sh
```
</details>

### Install

```bash
git clone https://github.com/bluzername/claude-code-power-stack.git
cd claude-code-power-stack
./install.sh
```

The install script will:
1. Install Ghost and register it as an MCP server
2. Install cc-conversation-search and build the initial index
3. Copy the `/rename-session` command to your Claude Code config
4. Copy the planning-with-files skill to your Claude Code config
5. Update your CLAUDE.md with usage instructions

### Manual install

If you prefer to install components individually:

```bash
# Ghost
go install github.com/wcatz/ghost/cmd/ghost@latest
ghost mcp init

# cc-conversation-search
uv tool install cc-conversation-search
cc-conversation-search init

# Commands and skills (copy to your Claude Code config)
cp commands/rename-session.md ~/.claude/commands/
cp -r skills/planning-with-files ~/.claude/skills/
cp rules/session-naming.md ~/.claude/rules/common/
```

### Verify

```bash
./verify.sh
```

### Troubleshooting

<details>
<summary><b>Ghost not found after install</b></summary>

Go installs binaries to `$(go env GOPATH)/bin`. If that's not on your PATH:
```bash
# Quick fix - symlink to a PATH directory
ln -sf $(go env GOPATH)/bin/ghost /opt/homebrew/bin/ghost  # macOS
ln -sf $(go env GOPATH)/bin/ghost /usr/local/bin/ghost     # Linux
```
</details>

<details>
<summary><b>ghost mcp init fails or hangs</b></summary>

Register manually:
```bash
claude mcp add ghost -- $(which ghost) mcp
```
Then restart Claude Code.
</details>

<details>
<summary><b>ccs shows no results</b></summary>

The index might be empty or stale. Re-index all conversations:
```bash
ccs ix
```
If still empty, check that `~/.claude/projects/` contains `.jsonl` conversation files.
</details>

<details>
<summary><b>/plan or /rename-session not showing up</b></summary>

Restart Claude Code after install. If still missing, check the files exist:
```bash
ls ~/.claude/commands/rename-session.md
ls ~/.claude/skills/planning-with-files/SKILL.md
```
If not, re-run `./install.sh` from the repo directory.
</details>

<details>
<summary><b>Ghost MCP shows "not connected" in new session</b></summary>

Ghost needs a full Claude Code restart (not just a new session). Quit and relaunch Claude Code. Verify with `ghost mcp status`.
</details>

---

## Usage Guide

### Your new session lifecycle

#### 1. Start a session

```bash
cd ~/my-project
claude
```

Two things happen automatically:
- **Ghost** loads relevant project context via its SessionStart hook
- Claude suggests a **session name** based on your first message

#### 2. Name the session

When Claude suggests a name, accept or adjust it. The convention is:

```
{project}-{type}-{descriptor}
```

| Part | Values | Example |
|------|--------|---------|
| project | Short slug for your project | `api`, `mobile`, `infra` |
| type | `feat`, `fix`, `debug`, `explore`, `review`, `plan`, `research`, `comms` | `feat` |
| descriptor | 2-3 hyphenated words | `auth-flow` |

Examples: `api-feat-auth-flow`, `mobile-fix-crash-on-login`, `infra-plan-k8s-migration`

#### 3. For complex tasks, use /plan

If your task has 3+ steps or will take more than 10 minutes, say `/plan`. This creates three files **in your project directory**:

| File | Purpose | Analogy |
|------|---------|---------|
| `task_plan.md` | Roadmap with phases | Your GPS route |
| `findings.md` | Research notes and discoveries | Your notebook |
| `progress.md` | Session log of what happened | Your journal |

These files survive context compression, session restarts, and time away from the project.

#### 4. Work normally

Ghost silently records decisions in the background. If you used `/plan`, Claude updates the planning files as you work through phases.

#### 5. Resume later

```bash
# Option A: Search for the session
ccs "auth flow"
claude --resume <session-id>

# Option B: Start fresh in the same project dir
cd ~/my-project
claude
# Ghost auto-loads context, planning files provide phase-by-phase state
```

---

## Deep Dive: Each Tool

### Ghost - Persistent Memory

Ghost is an MCP server that gives Claude Code unlimited, categorized memory with importance scoring and time decay.

**What it captures automatically:**
- Decisions and their rationale
- Mistakes and how they were resolved
- Conventions and patterns specific to your project
- Technical context (architecture, dependencies, gotchas)

**Key behaviors:**
- Conventions never decay (they're always relevant)
- Gotchas fade after 30 days (they become stale)
- Memories are scored by importance (0.0 - 1.0)
- Full-text search across all memories

**You don't need to do anything.** Ghost operates through MCP tools that Claude calls automatically. It replaces the built-in MEMORY.md system (which has a 200-line cap) with unlimited SQLite-backed storage.

**Useful commands:**
```bash
ghost mcp status        # Check integration health
ghost search "auth"     # Search memories from terminal
```

### cc-conversation-search - Find Any Session

A CLI tool that indexes all your Claude Code conversations and lets you search across projects.

**Usage** (via `ccs` shortcut - installed to your PATH):
```bash
# Search by topic
ccs "database migration"

# Search with date filter
ccs "auth" --since 2025-03-01

# Search last 7 days only
ccs "auth" -d 7

# List recent sessions
ccs ls

# Resume a found session
ccs go <session-id>
```

**The index updates automatically** before each search (JIT indexing). For a full re-index:
```bash
ccs ix
```

### /rename-session - Session Naming

A Claude Code command that analyzes your current conversation and suggests a structured name.

**Just say** `/rename-session` **at the start of any substantive work.** Claude will suggest a name like `api-feat-auth-flow` based on what you're working on.

Why this matters: when you have 50+ sessions across 10 projects, `api-feat-auth-flow` is findable. `explain this function` is not.

### /plan - Planning with Files

The most powerful tool in the stack for complex work. Based on [Manus](https://manus.im/)'s approach of treating the filesystem as external memory.

**When to use /plan:**
- Task has 3+ distinct steps
- Task involves research then implementation
- Session will be long (50+ tool calls)
- Work spans multiple sessions

**When to skip /plan:**
- Quick question or lookup
- Single file edit
- Simple, known fix

#### The three files

**task_plan.md** - Your roadmap:
```markdown
## Goal
Add JWT authentication to the API

## Phases
- [x] Phase 1: Research JWT libraries
- [x] Phase 2: Implement token generation
- [ ] Phase 3: Add middleware
- [ ] Phase 4: Integration tests

## Decisions Made
- Using jose library (maintained, supports RS256)
- Tokens expire after 24h, refresh tokens after 7d

## Errors Encountered
- jsonwebtoken package deprecated - switched to jose
```

**findings.md** - Your research notebook:
```markdown
## Research Findings
- jose library: github.com/panva/jose - 4.2k stars, active maintenance
- JWT best practices: use RS256 for public APIs, HS256 for internal

## Technical Decisions
- RS256 for API tokens (allows public key verification)
- Refresh token rotation (each use generates new refresh token)
```

**progress.md** - Your session log:
```markdown
## Session: 2025-03-25
### Phase 1: Research JWT libraries [COMPLETE]
- Evaluated jsonwebtoken, jose, fast-jwt
- jose wins: maintained, spec-compliant, tree-shakeable

### Phase 2: Implement token generation [COMPLETE]
- Created src/auth/tokens.ts
- Added RS256 key pair generation script
- Unit tests passing (12/12)
```

#### The key discipline: the 2-action rule

After every 2 searches, file reads, or web lookups - **immediately save findings to findings.md**. Claude's context window is like RAM. Planning files are your disk. Don't let important discoveries exist only in volatile memory.

#### Context recovery

When you come back to a project after days or weeks:
1. Start Claude in the project directory
2. Ghost loads project-level memory automatically
3. If planning files exist, Claude reads them and knows exactly where you left off
4. "You were on Phase 3, middleware. JWT generation is done. Next: add auth middleware to Express routes."

---

## Decision Tree

```
Starting a session?
  --> Ghost auto-loads context (SessionStart hook)
  --> Claude suggests /rename-session

Complex task (3+ steps)?
  --> Say "/plan" to create planning files
  --> Work phase by phase

Simple task or quick question?
  --> Just do it. Ghost captures decisions silently.

Need to find old work?
  --> ccs "<topic>"
  --> claude --resume <session-id>

Coming back after days/weeks?
  --> If /plan was used: planning files = instant recovery
  --> If not: Ghost + cc-conversation-search reconstruct context
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Name session | `/rename-session` |
| Start planning | `/plan` |
| Search past sessions | `ccs "query"` |
| List recent sessions | `ccs ls` |
| Resume session | `ccs go <session-id>` |
| Check Ghost health | `ghost mcp status` |
| Re-index conversations | `ccs ix` |

---

## Project Structure

```
claude-code-power-stack/
  install.sh              # One-command setup
  verify.sh               # Post-install verification
  uninstall.sh            # Clean removal
  bin/
    ccs                   # Search shortcut (3 keystrokes)
  commands/
    rename-session.md     # /rename-session command
  skills/
    planning-with-files/  # /plan skill (full Manus-style planning)
  rules/
    session-naming.md     # Auto-suggest session naming
  templates/
    claude-md-snippet.md  # CLAUDE.md additions
  docs/
    cheatsheet.md         # One-page quick reference
    workflow-guide.md     # Detailed workflow guide
```

---

## FAQ

**Does Ghost replace CLAUDE.md / MEMORY.md?**
Ghost replaces the auto memory system (MEMORY.md). CLAUDE.md remains your project-level instructions file - Ghost doesn't touch it.

**Do I need an Anthropic API key for Ghost?**
No. Ghost's MCP server works through Claude Code's existing connection. You only need an API key if you want Ghost's standalone features (CLI chat, memory consolidation).

**How much disk space does this use?**
Ghost's SQLite database is typically <10MB. cc-conversation-search's index is proportional to your conversation history - typically 5-50MB.

**Can I use this with Cursor / other MCP clients?**
Ghost works with any MCP client. cc-conversation-search is Claude Code-specific (it reads Claude Code's conversation files). The planning-with-files skill is Claude Code-specific.

**What if I don't use Go?**
Ghost is the only component requiring Go. You can install it via `brew install wcatz/tap/ghost` if you prefer not to use `go install`.

---

## Contributing

PRs welcome. If you find a workflow pattern that works well with this stack, open an issue or PR to add it to the guide.

## License

MIT

## Credits

- [Ghost](https://github.com/wcatz/ghost) by wcatz
- [cc-conversation-search](https://github.com/akatz-ai/cc-conversation-search) by akatz-ai
- Planning-with-files based on [Manus](https://manus.im/) context engineering principles
- Maintained by [@bluzername](https://github.com/bluzername)
