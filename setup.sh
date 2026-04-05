#!/bin/bash
# Claude Orchestrator — automated setup
# Run this or let Claude Code run it for you.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================"
echo "  Claude Orchestrator Setup"
echo "========================================"
echo

# 1. Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

check_cmd() {
  if command -v "$1" &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $1"
    return 0
  else
    echo -e "  ${RED}✗${NC} $1 — $2"
    return 1
  fi
}

MISSING=0
check_cmd claude "Install: npm install -g @anthropic-ai/claude-code" || MISSING=1
check_cmd tmux "Install: brew install tmux" || MISSING=1
check_cmd ngrok "Install: brew install ngrok" || MISSING=1
check_cmd node "Install: brew install node" || MISSING=1
check_cmd python3 "Install: brew install python" || MISSING=1
check_cmd osascript "macOS required (AppleScript)" || MISSING=1

if [ "$MISSING" = "1" ]; then
  echo -e "\n${RED}Install missing prerequisites and re-run.${NC}"
  exit 1
fi

echo

# 2. Install claude-sessions CLI
echo -e "${YELLOW}Installing claude-sessions CLI...${NC}"
mkdir -p ~/.local/bin
cp "$SCRIPT_DIR/bin/claude-sessions" ~/.local/bin/claude-sessions
chmod +x ~/.local/bin/claude-sessions

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo -e "  ${YELLOW}Adding ~/.local/bin to PATH...${NC}"
  SHELL_RC="$HOME/.zshrc"
  [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.bashrc"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  export PATH="$HOME/.local/bin:$PATH"
  echo "  Added to $SHELL_RC — restart your shell or run: source $SHELL_RC"
fi

echo -e "  ${GREEN}✓${NC} claude-sessions installed to ~/.local/bin/"
echo

# 3. Install bridge server dependencies
echo -e "${YELLOW}Installing bridge server dependencies...${NC}"
cd "$SCRIPT_DIR/bridge"
npm install --quiet
cd "$SCRIPT_DIR"
echo -e "  ${GREEN}✓${NC} npm packages installed"
echo

# 4. Create .env if needed
if [ ! -f "$SCRIPT_DIR/.env" ]; then
  echo -e "${YELLOW}Creating .env from template...${NC}"
  cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
  echo -e "  ${GREEN}✓${NC} .env created — edit it to add your API keys"
else
  echo -e "  ${GREEN}✓${NC} .env already exists"
fi
echo

# 5. Check Accessibility permissions
echo -e "${YELLOW}Checking Accessibility permissions...${NC}"
if osascript -e 'tell application "System Events" to keystroke ""' 2>/dev/null; then
  echo -e "  ${GREEN}✓${NC} Accessibility permissions OK"
else
  echo -e "  ${YELLOW}!${NC} Terminal.app needs Accessibility permissions"
  echo "  Go to: System Preferences > Privacy & Security > Accessibility"
  echo "  Add Terminal.app (or your terminal emulator)"
fi
echo

# 6. Summary
echo "========================================"
echo -e "${GREEN}Setup complete!${NC}"
echo "========================================"
echo
echo "Next steps:"
echo "  1. Edit .env with your RETELL_API_KEY (get one at https://app.retell.ai/settings)"
echo "  2. Start ngrok:           ngrok http 3456"
echo "  3. Set up voice agent:    node scripts/setup-retell.js"
echo "  4. Start bridge server:   node bridge/server.js"
echo "  5. Call your phone number!"
echo
echo "Quick test:"
echo "  claude-sessions list          # List all sessions"
echo "  claude-sessions list -a       # Active sessions only"
echo
echo "For Telegram integration, start Claude Code with:"
echo "  claude --channels plugin:telegram@claude-plugins-official"
echo
