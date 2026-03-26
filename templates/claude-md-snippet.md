## Memory & Context System

### Ghost (Persistent Memory)
Ghost MCP auto-captures decisions, mistakes, conventions, and patterns across all sessions.
- Memories are categorized with importance scoring and time decay
- Operates automatically - no manual intervention needed
- Legacy MEMORY.md files are read-only archives; do not update them

### Cross-Session Search
Find previous conversations using the `ccs` shortcut:
```bash
ccs "<query>"              # search (results are numbered)
ccs here "<query>"         # search current project only
ccs "<query>" -d 7         # last 7 days only
ccs ls                     # list recent sessions
ccs ls here                # list current project only
ccs go 1                   # resume result #1 from last search
ccs stats                  # usage dashboard
ccs doctor                 # health check
ccs cheat                  # quick reference in terminal
ccs update                 # update the stack
ccs ix                     # re-index all conversations
```

### Session Naming
Name sessions at the start of substantive work using `/rename-session`.
Convention: `{project}-{type}-{descriptor}`
Examples: `api-feat-auth-flow`, `mobile-fix-crash-on-login`, `infra-plan-k8s-migration`
