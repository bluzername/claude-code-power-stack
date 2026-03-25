## Memory & Context System

### Ghost (Persistent Memory)
Ghost MCP auto-captures decisions, mistakes, conventions, and patterns across all sessions.
- Memories are categorized with importance scoring and time decay
- Operates automatically - no manual intervention needed
- Legacy MEMORY.md files are read-only archives; do not update them

### Cross-Session Search
Find previous conversations using the `ccs` shortcut:
```bash
ccs "<query>"              # search all sessions
ccs "<query>" -d 7         # last 7 days only
ccs ls                     # list recent sessions
ccs go <session-id>        # resume a session
ccs ix                     # re-index all conversations
```

### Session Naming
Name sessions at the start of substantive work using `/rename-session`.
Convention: `{project}-{type}-{descriptor}`
Examples: `api-feat-auth-flow`, `mobile-fix-crash-on-login`, `infra-plan-k8s-migration`
