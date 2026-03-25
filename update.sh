#!/usr/bin/env bash
set -euo pipefail

# Claude Code Power Stack - Updater
# Updates all stack components to latest versions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo ""
echo "Claude Code Power Stack - Updater"
echo "=================================="
echo ""

# ------------------------------------------
# Pull latest repo and show what changed
# ------------------------------------------

echo "--- Repo ---"
if [ -d "$SCRIPT_DIR/.git" ]; then
    OLD_HEAD=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null)
    info "Pulling latest..."
    git -C "$SCRIPT_DIR" pull --ff-only 2>&1 | tail -1
    NEW_HEAD=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null)

    if [ "$OLD_HEAD" != "$NEW_HEAD" ]; then
        echo ""
        echo -e "  ${BOLD}What's new:${NC}"
        git -C "$SCRIPT_DIR" log --oneline "${OLD_HEAD}..${NEW_HEAD}" | while read -r line; do
            echo -e "    ${GREEN}+${NC} $line"
        done
        echo ""
    else
        ok "Already up to date"
    fi
else
    warn "Not a git repo - skip repo update"
fi
echo ""

# ------------------------------------------
# Update Ghost
# ------------------------------------------

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

# ------------------------------------------
# Update cc-conversation-search
# ------------------------------------------

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

# ------------------------------------------
# Re-copy ccs shortcut
# ------------------------------------------

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

# ------------------------------------------
# Re-copy commands, skills, rules, completions
# ------------------------------------------

echo "--- Commands, skills & completions ---"
mkdir -p "$CLAUDE_DIR/commands" "$CLAUDE_DIR/rules/common" "$CLAUDE_DIR/skills"

# Commands
for cmd_file in "$SCRIPT_DIR"/commands/*.md; do
    [ -f "$cmd_file" ] || continue
    cp "$cmd_file" "$CLAUDE_DIR/commands/"
    ok "Updated /$(basename "${cmd_file%.md}")"
done

# Skills
if [ -d "$SCRIPT_DIR/skills/planning-with-files" ]; then
    rm -rf "$CLAUDE_DIR/skills/planning-with-files" 2>/dev/null
    cp -r "$SCRIPT_DIR/skills/planning-with-files" "$CLAUDE_DIR/skills/planning-with-files"
    ok "Updated planning-with-files"
fi

# Rules
[ -f "$SCRIPT_DIR/rules/session-naming.md" ] && cp "$SCRIPT_DIR/rules/session-naming.md" "$CLAUDE_DIR/rules/common/" && ok "Updated session-naming rule"

# Completions
SHELL_NAME="$(basename "$SHELL")"
if [ "$SHELL_NAME" = "zsh" ] && [ -f "$SCRIPT_DIR/completions/_ccs" ]; then
    mkdir -p "${HOME}/.zsh/completions"
    cp "$SCRIPT_DIR/completions/_ccs" "${HOME}/.zsh/completions/_ccs"
    ok "Updated zsh completions"
elif [ "$SHELL_NAME" = "bash" ] && [ -f "$SCRIPT_DIR/completions/ccs.bash" ]; then
    mkdir -p "${HOME}/.local/share/bash-completion/completions"
    cp "$SCRIPT_DIR/completions/ccs.bash" "${HOME}/.local/share/bash-completion/completions/ccs"
    ok "Updated bash completions"
fi

echo ""
echo "=================================="
echo "  Update complete!"
echo "=================================="
echo "  Restart Claude Code to pick up any MCP changes."
echo ""
