#!/usr/bin/env bash
set -euo pipefail

# Claude Code Power Stack - Installer
# https://github.com/bluzername/claude-code-power-stack

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }

echo ""
echo "======================================"
echo "  Claude Code Power Stack - Installer"
echo "======================================"
echo ""

# ------------------------------------------
# Pre-flight checks
# ------------------------------------------

MISSING=0

if ! command -v claude &>/dev/null; then
    fail "Claude Code CLI not found. Install it first: https://docs.anthropic.com/en/docs/claude-code"
    MISSING=1
fi

if ! command -v go &>/dev/null && ! command -v brew &>/dev/null; then
    fail "Neither Go nor Homebrew found. Need one to install Ghost."
    MISSING=1
fi

if ! command -v uv &>/dev/null && ! command -v pip &>/dev/null; then
    fail "Neither uv nor pip found. Need one to install cc-conversation-search."
    MISSING=1
fi

if [ "$MISSING" -eq 1 ]; then
    echo ""
    fail "Missing prerequisites. Install them and re-run."
    exit 1
fi

if [ ! -d "$CLAUDE_DIR" ]; then
    fail "Claude Code config directory not found at $CLAUDE_DIR"
    fail "Run Claude Code at least once first."
    exit 1
fi

ok "Prerequisites check passed"
echo ""

# ------------------------------------------
# Step 1: Install Ghost
# ------------------------------------------

echo "--- Step 1/5: Ghost (persistent memory) ---"

if command -v ghost &>/dev/null; then
    ok "Ghost already installed: $(ghost --version 2>/dev/null || echo 'unknown version')"
else
    if command -v go &>/dev/null; then
        info "Installing Ghost via Go..."
        go install github.com/wcatz/ghost/cmd/ghost@latest

        # Add to PATH if needed
        GHOST_BIN="$(go env GOPATH)/bin/ghost"
        if [ -f "$GHOST_BIN" ] && ! command -v ghost &>/dev/null; then
            if [ -d "/opt/homebrew/bin" ]; then
                ln -sf "$GHOST_BIN" /opt/homebrew/bin/ghost
            elif [ -d "/usr/local/bin" ]; then
                ln -sf "$GHOST_BIN" /usr/local/bin/ghost
            else
                warn "Ghost installed at $GHOST_BIN but not on PATH."
                warn "Add $(go env GOPATH)/bin to your PATH."
            fi
        fi
    elif command -v brew &>/dev/null; then
        info "Installing Ghost via Homebrew..."
        brew install wcatz/tap/ghost
    fi

    if command -v ghost &>/dev/null; then
        ok "Ghost installed: $(ghost --version 2>/dev/null || echo 'ok')"
    else
        fail "Ghost installation failed. Install manually:"
        fail "  go install github.com/wcatz/ghost/cmd/ghost@latest"
        fail "  OR brew install wcatz/tap/ghost"
    fi
fi

echo ""

# ------------------------------------------
# Step 2: Register Ghost MCP
# ------------------------------------------

echo "--- Step 2/5: Register Ghost with Claude Code ---"

if command -v ghost &>/dev/null; then
    info "Running ghost mcp init..."
    if ghost mcp init 2>&1; then
        ok "Ghost MCP registered"
    else
        warn "ghost mcp init had issues. Trying manual registration..."
        claude mcp add ghost -- "$(command -v ghost)" mcp 2>/dev/null && ok "Manual registration succeeded" || warn "Manual registration failed - register manually after install"
    fi
else
    warn "Ghost not on PATH - skipping MCP registration"
fi

echo ""

# ------------------------------------------
# Step 3: Install cc-conversation-search
# ------------------------------------------

echo "--- Step 3/5: cc-conversation-search (cross-project search) ---"

if command -v cc-conversation-search &>/dev/null; then
    ok "cc-conversation-search already installed"
else
    if command -v uv &>/dev/null; then
        info "Installing via uv..."
        uv tool install cc-conversation-search
    elif command -v pip &>/dev/null; then
        info "Installing via pip..."
        pip install cc-conversation-search
    fi

    if command -v cc-conversation-search &>/dev/null; then
        ok "cc-conversation-search installed"
    else
        fail "Installation failed. Install manually:"
        fail "  uv tool install cc-conversation-search"
    fi
fi

if command -v cc-conversation-search &>/dev/null; then
    info "Building conversation index (this may take a minute)..."
    cc-conversation-search init 2>&1 | tail -3
    ok "Conversation index built"
fi

echo ""

# ------------------------------------------
# Step 4: Copy commands, skills, and rules
# ------------------------------------------

echo "--- Step 4/5: Commands, skills, and rules ---"

# Commands
mkdir -p "$CLAUDE_DIR/commands"
if [ -f "$SCRIPT_DIR/commands/rename-session.md" ]; then
    cp "$SCRIPT_DIR/commands/rename-session.md" "$CLAUDE_DIR/commands/"
    ok "Installed /rename-session command"
else
    warn "commands/rename-session.md not found in repo"
fi

# Skills
mkdir -p "$CLAUDE_DIR/skills"
if [ -d "$SCRIPT_DIR/skills/planning-with-files" ]; then
    cp -r "$SCRIPT_DIR/skills/planning-with-files" "$CLAUDE_DIR/skills/"
    ok "Installed planning-with-files skill"
else
    warn "skills/planning-with-files not found in repo"
fi

# Rules
mkdir -p "$CLAUDE_DIR/rules/common"
if [ -f "$SCRIPT_DIR/rules/session-naming.md" ]; then
    cp "$SCRIPT_DIR/rules/session-naming.md" "$CLAUDE_DIR/rules/common/"
    ok "Installed session-naming rule"
else
    warn "rules/session-naming.md not found in repo"
fi

echo ""

# ------------------------------------------
# Step 5: Update CLAUDE.md
# ------------------------------------------

echo "--- Step 5/5: Update CLAUDE.md ---"

CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
SNIPPET="$SCRIPT_DIR/templates/claude-md-snippet.md"

if [ -f "$SNIPPET" ]; then
    if [ -f "$CLAUDE_MD" ]; then
        if grep -q "Memory & Context System" "$CLAUDE_MD" 2>/dev/null; then
            ok "CLAUDE.md already contains Memory & Context System section"
        else
            echo "" >> "$CLAUDE_MD"
            cat "$SNIPPET" >> "$CLAUDE_MD"
            ok "Added Memory & Context System section to CLAUDE.md"
        fi
    else
        cp "$SNIPPET" "$CLAUDE_MD"
        ok "Created CLAUDE.md with Memory & Context System section"
    fi
else
    warn "templates/claude-md-snippet.md not found - skipping CLAUDE.md update"
fi

echo ""
echo "======================================"
echo "  Installation complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to activate Ghost MCP"
echo "  2. Run ./verify.sh to confirm everything works"
echo "  3. Start a session and try: /rename-session"
echo "  4. For complex tasks, try: /plan"
echo ""
echo "Quick reference:"
echo "  Search sessions:  cc-conversation-search search \"<query>\""
echo "  Resume session:   claude --resume <session-id>"
echo "  Ghost health:     ghost mcp status"
echo ""
