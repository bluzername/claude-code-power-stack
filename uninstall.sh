#!/usr/bin/env bash
set -uo pipefail

# Claude Code Power Stack - Uninstaller

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "  ${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "  ${YELLOW}[SKIP]${NC} $*"; }

echo ""
echo "Claude Code Power Stack - Uninstaller"
echo "======================================"
echo ""
echo "This removes the stack components from Claude Code."
echo "Ghost and cc-conversation-search binaries are left installed."
echo ""
read -rp "Continue? [y/N] " confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# Remove MCP registration (check both scopes)
if command -v claude &>/dev/null; then
    claude mcp remove ghost -s user 2>/dev/null && info "Removed Ghost MCP registration (user scope)" || true
    claude mcp remove ghost -s project 2>/dev/null && info "Removed Ghost MCP registration (project scope)" || true
    if ! claude mcp list 2>&1 | grep -q ghost; then
        info "Ghost MCP fully removed"
    else
        warn "Ghost MCP may still be registered in another scope"
    fi
fi

# Remove commands
if [ -f "${HOME}/.claude/commands/rename-session.md" ]; then
    rm "${HOME}/.claude/commands/rename-session.md"
    info "Removed /rename-session command"
else
    warn "/rename-session command not found"
fi

# Remove rules
if [ -f "${HOME}/.claude/rules/common/session-naming.md" ]; then
    rm "${HOME}/.claude/rules/common/session-naming.md"
    info "Removed session-naming rule"
else
    warn "session-naming rule not found"
fi

# Remove ccs shortcut
for dir in /opt/homebrew/bin /usr/local/bin "${HOME}/.local/bin"; do
    if [ -f "$dir/ccs" ]; then
        rm "$dir/ccs"
        info "Removed ccs from $dir"
        break
    fi
done

# Remove shell completions
[ -f "${HOME}/.zsh/completions/_ccs" ] && rm "${HOME}/.zsh/completions/_ccs" && info "Removed zsh completions"
[ -f "${HOME}/.local/share/bash-completion/completions/ccs" ] && rm "${HOME}/.local/share/bash-completion/completions/ccs" && info "Removed bash completions"
[ -f "${HOME}/.ccs_last_results" ] && rm "${HOME}/.ccs_last_results" && info "Removed ccs cache"

echo ""
echo "Done. Note:"
echo "  - Ghost and cc-conversation-search binaries still installed"
echo "  - To fully remove Ghost: go clean -i github.com/wcatz/ghost/cmd/ghost"
echo "  - To fully remove cc-conversation-search: uv tool uninstall cc-conversation-search"
echo "  - CLAUDE.md memory section left intact (remove manually if desired)"
echo "  - planning-with-files skill left intact (remove ~/.claude/skills/planning-with-files/ manually)"
echo ""
