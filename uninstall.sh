#!/usr/bin/env bash
set -uo pipefail

# Claude Code Power Stack - Uninstaller

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CLAUDE_DIR="${CLAUDE_DIR:-${HOME}/.claude}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0
LOCAL_ONLY="${POWER_STACK_LOCAL_ONLY:-0}"
for arg in "$@"; do
    case "$arg" in
        -y|--yes) YES=1 ;;
        --local-only) LOCAL_ONLY=1 ;;
        *) echo "Unknown argument: $arg" >&2; exit 2 ;;
    esac
done

info()  { echo -e "  ${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "  ${YELLOW}[SKIP]${NC} $*"; }

echo ""
echo "Claude Code Power Stack - Uninstaller"
echo "======================================"
echo ""
echo "This removes the stack components from Claude Code."
echo "Ghost and cc-conversation-search binaries are left installed."
echo ""
if [ "$YES" -eq 0 ]; then
    read -rp "Continue? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""

# Remove MCP registration (check both scopes)
if [ "$LOCAL_ONLY" -eq 0 ] && command -v claude &>/dev/null; then
    if claude mcp remove ghost -s user 2>/dev/null; then
        info "Removed Ghost MCP registration (user scope)"
    fi
    if claude mcp remove ghost -s project 2>/dev/null; then
        info "Removed Ghost MCP registration (project scope)"
    fi
    if ! claude mcp list 2>&1 | grep -q ghost; then
        info "Ghost MCP fully removed"
    else
        warn "Ghost MCP may still be registered in another scope"
    fi
fi

# Remove every command this repo ships
for cmd_file in "$SCRIPT_DIR"/commands/*.md; do
    name="$(basename "$cmd_file")"
    if [ -f "$CLAUDE_DIR/commands/$name" ]; then
        rm "$CLAUDE_DIR/commands/$name"
        info "Removed /${name%.md} command"
    else
        warn "/${name%.md} command not found"
    fi
done

# Remove rules
if [ -f "${CLAUDE_DIR}/rules/common/session-naming.md" ]; then
    rm "${CLAUDE_DIR}/rules/common/session-naming.md"
    info "Removed session-naming rule"
else
    warn "session-naming rule not found"
fi

# Remove ccs shortcut, completions and cache (skipped with --local-only)
if [ "$LOCAL_ONLY" -eq 0 ]; then
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
fi # LOCAL_ONLY

echo ""
echo "Done. Note:"
echo "  - Ghost and cc-conversation-search binaries still installed"
echo "  - To fully remove Ghost: go clean -i github.com/wcatz/ghost/cmd/ghost"
echo "  - To fully remove cc-conversation-search: uv tool uninstall cc-conversation-search"
echo "  - CLAUDE.md memory section left intact (remove manually if desired)"
echo "  - planning-with-files skill left intact (remove ~/.claude/skills/planning-with-files/ manually)"
echo ""
