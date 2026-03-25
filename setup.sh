#!/usr/bin/env bash
set -euo pipefail

# Claude Code Power Stack - Remote Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/bluzername/claude-code-power-stack/main/setup.sh | bash
#
# Clones the repo, runs install.sh, and keeps the repo for future updates.

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/bluzername/claude-code-power-stack.git"
INSTALL_DIR="${CLAUDE_POWER_STACK_DIR:-${HOME}/.claude-power-stack}"

echo ""
echo -e "${BLUE}Claude Code Power Stack - Remote Installer${NC}"
echo "============================================"
echo ""

# Check git
if ! command -v git &>/dev/null; then
    echo -e "${RED}git is required but not found.${NC}"
    exit 1
fi

# Clone or update
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${GREEN}[OK]${NC} Repo exists at $INSTALL_DIR - pulling latest..."
    git -C "$INSTALL_DIR" pull --ff-only 2>&1 | tail -1
else
    echo "Cloning to $INSTALL_DIR..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR" 2>&1 | tail -1
fi

echo ""

# Run the install script
cd "$INSTALL_DIR"
exec bash ./install.sh
