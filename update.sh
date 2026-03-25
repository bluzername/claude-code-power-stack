#!/usr/bin/env bash
set -euo pipefail

# Claude Code Power Stack - Updater
# Updates all stack components to latest versions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Claude Code Power Stack - Updater"
echo "=================================="
echo ""

# Update repo itself
echo "--- Repo ---"
if [ -d "$SCRIPT_DIR/.git" ]; then
    info "Pulling latest..."
    git -C "$SCRIPT_DIR" pull --ff-only 2>&1 | tail -1
    ok "Repo updated"
else
    warn "Not a git repo - skip repo update"
fi
echo ""

# Update Ghost
echo "--- Ghost ---"
if command -v go &>/dev/null; then
    info "Updating Ghost..."
    go install github.com/wcatz/ghost/cmd/ghost@latest 2>&1 | tail -1
    ok "Ghost updated: $(ghost --version 2>/dev/null || echo 'ok')"
elif command -v brew &>/dev/null && brew list wcatz/tap/ghost &>/dev/null 2>&1; then
    info "Updating Ghost via Homebrew..."
    brew upgrade wcatz/tap/ghost 2>&1 | tail -1
    ok "Ghost updated"
else
    warn "Ghost not updatable (no go or brew)"
fi
echo ""

# Update cc-conversation-search
echo "--- cc-conversation-search ---"
if command -v uv &>/dev/null; then
    info "Updating cc-conversation-search..."
    uv tool upgrade cc-conversation-search 2>&1 | tail -1
    ok "cc-conversation-search updated"
elif command -v pip &>/dev/null; then
    info "Updating cc-conversation-search..."
    pip install --upgrade cc-conversation-search 2>&1 | tail -1
    ok "cc-conversation-search updated"
else
    warn "Cannot update cc-conversation-search (no uv or pip)"
fi
echo ""

# Re-copy ccs shortcut (may have changes)
echo "--- ccs shortcut ---"
if [ -f "$SCRIPT_DIR/bin/ccs" ]; then
    for dir in /opt/homebrew/bin /usr/local/bin "${HOME}/.local/bin"; do
        if [ -f "$dir/ccs" ]; then
            cp "$SCRIPT_DIR/bin/ccs" "$dir/ccs"
            chmod +x "$dir/ccs"
            ok "Updated ccs at $dir/ccs"
            break
        fi
    done
fi
echo ""

# Re-copy commands, skills, rules (may have improvements)
echo "--- Commands & skills ---"
CLAUDE_DIR="${HOME}/.claude"
[ -f "$SCRIPT_DIR/commands/rename-session.md" ] && cp "$SCRIPT_DIR/commands/rename-session.md" "$CLAUDE_DIR/commands/" && ok "Updated /rename-session"
if [ -d "$SCRIPT_DIR/skills/planning-with-files" ]; then
    rm -rf "$CLAUDE_DIR/skills/planning-with-files" 2>/dev/null
    cp -r "$SCRIPT_DIR/skills/planning-with-files" "$CLAUDE_DIR/skills/planning-with-files"
    ok "Updated planning-with-files"
fi
[ -f "$SCRIPT_DIR/rules/session-naming.md" ] && cp "$SCRIPT_DIR/rules/session-naming.md" "$CLAUDE_DIR/rules/common/" && ok "Updated session-naming rule"
echo ""

echo "=================================="
echo "  Update complete!"
echo "=================================="
echo "  Restart Claude Code to pick up any MCP changes."
echo ""
