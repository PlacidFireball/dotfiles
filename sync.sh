#! /bin/zsh

autoload colors; colors

function warn_log {
  echo "$fg[yellow]$1$reset_color"
}

function error_log {
  echo "$fg[red]$1$reset_color"
}

function happy_log {
  echo "$fg[green]$1$reset_color"
}

function info_log {
  echo "$fg[blue]$1$reset_color"
}

# Source -> Destination mapping
# Using associative array for cleaner structure if zsh version allows, but simple checks are safer and more portable
# We'll just list them out.

# Function to sync a directory or file
function sync_config {
  local name="$1"
  local src="$2"
  local dest="$3"

  if [[ -e "$src" ]]; then
    info_log "Syncing $name..."
    # Ensure destination directory exists if it's a directory sync
    if [[ -d "$src" ]]; then
      mkdir -p "$dest"
      # Use rsync for better syncing if available, else cp
      if command -v rsync &> /dev/null; then
        rsync -av --delete --exclude '.git' --exclude '.DS_Store' --exclude 'node_modules' --exclude '.bun' "$src/" "$dest/"
      else
        # Fallback to cp, removing destination first to ensure clean sync
        rm -rf "$dest"
        cp -R "$src" "$dest"
      fi
    else
      # It's a file
      cp "$src" "$dest"
    fi
    happy_log "Synced $name from $src to $dest"
  else
    warn_log "Source $name not found at $src - skipping"
  fi
}

REPO_DIR="$HOME/build/dotfiles"

info_log "Starting configuration sync..."

# Neovim
sync_config "neovim" "$HOME/.config/nvim" "$REPO_DIR/nvim"

# Ghostty
sync_config "ghostty" "$HOME/.config/ghostty" "$REPO_DIR/ghostty"

# Kitty
sync_config "kitty" "$HOME/.config/kitty" "$REPO_DIR/kitty"

# Tmux
sync_config "tmux" "$HOME/.tmux.conf" "$REPO_DIR/.tmux.conf"

# Scripts
sync_config "scripts" "$HOME/.scripts" "$REPO_DIR/.scripts"

# Hyprland (only if present)
sync_config "hyprland" "$HOME/.config/hypr" "$REPO_DIR/hypr"

# Hyprpanel (only if present)
sync_config "hyprpanel" "$HOME/.config/hyprpanel" "$REPO_DIR/hyprpanel"

# Wofi (only if present)
sync_config "wofi" "$HOME/.config/wofi" "$REPO_DIR/wofi"

# Opencode (only if present)
sync_config "opencode" "$HOME/.config/opencode" "$REPO_DIR/opencode"

happy_log "Sync complete! Don't forget to check git status and commit your changes."
