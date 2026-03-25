# Contributing

PRs welcome. Here's what's most useful:

## Good PRs

- **New `ccs` subcommands** - if you find yourself wrapping `cc-conversation-search` in a script, it probably belongs in `ccs`
- **New slash commands** - `/standup` and `/rename-session` are examples. If you have a workflow command that ties the stack tools together, add it to `commands/`
- **Troubleshooting entries** - hit an install issue and figured it out? Add a `<details>` block to the README troubleshooting section
- **Bug fixes** - especially in `install.sh` and `ccs`
- **Platform support** - Linux fixes, WSL compatibility, etc.

## Before submitting

1. Run `bash -n` on any shell scripts you changed to check syntax
2. If you changed `ccs`, test the affected subcommands
3. If you changed the cheatsheet, regenerate the PDF: `cd docs && python3 generate-pdf.py`
4. Keep the README concise - new sections should use `<details>` blocks when possible

## What doesn't fit

- Adding new tools to the stack (Ghost + cc-conversation-search + planning-with-files is the scope)
- Large refactors of the install flow
- Features that require additional runtime dependencies

## Style

- Shell scripts: bash, `set -euo pipefail`, colored output with the existing `ok`/`warn`/`fail` helpers
- Commands (`.md` files): numbered steps, code blocks for anything runnable
- README: scannable, collapsible details for long content, tables over prose
