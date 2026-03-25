#!/usr/bin/env bash
set -uo pipefail

# Claude Code Power Stack - Verification
# Run after install.sh to confirm everything works

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check() {
    local desc="$1"
    shift
    if "$@" &>/dev/null; then
        echo -e "  ${GREEN}PASS${NC}  $desc"
        ((PASS++))
    else
        echo -e "  ${RED}FAIL${NC}  $desc"
        ((FAIL++))
    fi
}

check_warn() {
    local desc="$1"
    shift
    if "$@" &>/dev/null; then
        echo -e "  ${GREEN}PASS${NC}  $desc"
        ((PASS++))
    else
        echo -e "  ${YELLOW}WARN${NC}  $desc"
        ((WARN++))
    fi
}

echo ""
echo "Claude Code Power Stack - Verification"
echo "======================================="
echo ""

echo "Binaries:"
check "ghost on PATH" command -v ghost
check "cc-conversation-search on PATH" command -v cc-conversation-search
check "ccs shortcut on PATH" command -v ccs
check "claude on PATH" command -v claude
echo ""

echo "Ghost MCP:"
check "ghost mcp status passes" ghost mcp status
check "ghost visible in claude mcp list" bash -c "claude mcp list 2>&1 | grep -q ghost"
echo ""

echo "cc-conversation-search:"
check "search index exists" test -f "${HOME}/.conversation-search/index.db"
check_warn "search returns results" cc-conversation-search search "test" --limit 1
echo ""

echo "Claude Code config:"
check "/rename-session command" test -f "${HOME}/.claude/commands/rename-session.md"
check "session-naming rule" test -f "${HOME}/.claude/rules/common/session-naming.md"
check_warn "planning-with-files skill" test -d "${HOME}/.claude/skills/planning-with-files"
check_warn "CLAUDE.md has memory section" grep -q "Memory & Context System" "${HOME}/.claude/CLAUDE.md"
echo ""

echo "---------------------------------------"
echo -e "  ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC}, ${YELLOW}$WARN warnings${NC}"
echo "---------------------------------------"
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo "Some checks failed. Re-run install.sh or install components manually."
    exit 1
elif [ "$WARN" -gt 0 ]; then
    echo "All critical checks passed. Warnings are non-blocking."
    exit 0
else
    echo "All checks passed. Restart Claude Code and start using the stack."
    exit 0
fi
