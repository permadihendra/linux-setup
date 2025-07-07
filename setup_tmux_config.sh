#!/bin/bash

set -e

# -------- CONFIG --------
SHELL_RC="$HOME/.zshrc"  # Change to ~/.bashrc if needed

# -------- COLORS --------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -------- CHECK TMUX VERSION --------
echo -e "${GREEN}>> Checking tmux version...${NC}"
if ! command -v tmux &>/dev/null; then
  echo -e "${YELLOW}tmux is not installed. Please install it first from the official source.${NC}"
  exit 1
fi

TMUX_VERSION=$(tmux -V | awk '{print $2}')
REQUIRED_VERSION="3.2"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$TMUX_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
  echo -e "${YELLOW}Warning: tmux $TMUX_VERSION is lower than recommended $REQUIRED_VERSION for plugin compatibility.${NC}"
fi

# -------- WRITE ~/.tmux.conf --------
echo -e "${GREEN}>> Writing ~/.tmux.conf with continuum and UX improvements...${NC}"
cat > ~/.tmux.conf <<'EOF'
# --- Mouse support ---
set -g mouse on

# --- Copy mode with Vim keys ---
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# --- Pane indexing ---
set -g base-index 1
setw -g pane-base-index 1
set -g history-limit 10000

# --- Status Bar ---
set -g status-bg colour235
set -g status-fg colour136
set -g status-interval 5
set -g status-left-length 40
set -g status-right-length 120
set -g status-left '#[fg=green]#S #[default]'
set -g status-right '#[fg=cyan]%Y-%m-%d #[fg=white]%H:%M:%S #[default]'

# --- Plugin Manager ---
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# --- Resurrect Settings ---
set -g @resurrect-capture-pane-contents 'on'

# --- Continuum Settings ---
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# --- Load Plugins ---
run '~/.tmux/plugins/tpm/tpm'
EOF

# -------- INSTALL TPM --------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo -e "${GREEN}>> Installing TPM...${NC}"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo -e "${GREEN}>> TPM already installed.${NC}"
fi

# -------- AUTOLOAD TMUX IN SHELL --------
echo -e "${GREEN}>> Configuring autoload in $SHELL_RC...${NC}"
AUTOLOAD_BLOCK="
# >>> Tmux auto-start >>>
if command -v tmux &>/dev/null && [ -z \"\$TMUX\" ] && [ -z \"\$SSH_CONNECTION\" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi
# <<< Tmux auto-start <<<"

if ! grep -q 'Tmux auto-start' "$SHELL_RC"; then
  echo "$AUTOLOAD_BLOCK" >> "$SHELL_RC"
  echo -e "${GREEN}>> Appended tmux autostart to $SHELL_RC${NC}"
else
  echo -e "${YELLOW}>> Autostart block already exists in $SHELL_RC${NC}"
fi

# -------- DONE --------
echo -e "${GREEN}>> Setup complete!${NC}"
echo -e "${YELLOW}Start tmux and press: Ctrl-b then Shift-I to install plugins.${NC}"
echo -e "${YELLOW}Session will auto-save every 15 mins and auto-restore on launch via tmux-continuum.${NC}"
