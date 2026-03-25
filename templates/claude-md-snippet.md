## Memory & Context System

### Ghost (Persistent Memory)
Ghost MCP auto-captures decisions, mistakes, conventions, and patterns across all sessions.
- Memories are categorized with importance scoring and time decay
- Operates automatically - no manual intervention needed
- Legacy MEMORY.md files are read-only archives; do not update them

### Cross-Session Search
Find previous conversations:
```bash
cc-conversation-search search "<query>"
cc-conversation-search search "<query>" --since 2025-03-01
cc-conversation-search list --days 7
```
Use returned session ID with `claude --resume <session-id>` to continue.

### Session Naming
Name sessions at the start of substantive work using `/rename-session`.
Convention: `{project}-{type}-{descriptor}`
Examples: `api-feat-auth-flow`, `mobile-fix-crash-on-login`, `infra-plan-k8s-migration`
