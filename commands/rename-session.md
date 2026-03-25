## /rename-session - Name this session for easy retrieval

Analyze the current conversation and rename the session using a structured convention.

### Convention
```
{project}-{type}-{descriptor}
```

**project**: Short slug derived from the working directory or conversation context (e.g., `api`, `mobile`, `infra`, `docs`)

**type**: One of:
- `feat` - new feature
- `fix` - bug fix
- `debug` - debugging session
- `explore` - research/exploration
- `review` - code review
- `plan` - planning/architecture
- `research` - deep research
- `comms` - communications

**descriptor**: 2-3 hyphenated words describing the specific task

### Examples
- `api-feat-auth-flow`
- `mobile-fix-crash-on-login`
- `infra-plan-k8s-migration`
- `docs-feat-api-reference`

### Steps
1. Identify the project from the current working directory path or conversation topic
2. Determine the task type from the user's request
3. Create a concise 2-3 word descriptor
4. Run: `/rename {project}-{type}-{descriptor}`
