#! /bin/zsh

# True iff all arguments are executable in $PATH
function is_bin_in_path {
  if [[ -n $ZSH_VERSION ]]; then
    builtin whence -p "$1" &> /dev/null
  else  # bash:
    builtin type -P "$1" &> /dev/null
  fi
  [[ $? -ne 0 ]] && return 1
  if [[ $# -gt 1 ]]; then
    shift  # We've just checked the first one
    is_bin_in_path "$@"
  fi
}

DOTFILES_BUILD_DIR="$HOME/build/dotfiles/"

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

function backup_and_copy {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" ]]; then
    local backup="${dest}.old"
    rm -rf "$backup"
    mv "$dest" "$backup"
    warn_log "Backed up existing $(basename "$dest") to $backup"
  fi

  mkdir -p "$(dirname "$dest")"
  cp -r "$src" "$dest"
}

while [[ "$#" -gt 0 ]] do 
case $1 in
  --no-neovim) NO_NEOVIM="Y";;
  --no-hypr) NO_HYPR="Y";;
  --no-waybar) NO_WAYBAR="Y";;
  --no-term) NO_TERM="Y";;
  --no-opencode) NO_OPENCODE="Y";;
  *) error_log "Unknown argument passed: $1"
  exit 1;;
esac
shift
done

info_log "Syncing .config files!"

backup_and_copy "$DOTFILES_BUILD_DIR/.scripts" "$HOME/.scripts"

info_log "Synced .scripts folder to $HOME"

# tmux, wezterm
if [[ ! "$NO_TERM" == "Y" ]]; then
  backup_and_copy "$DOTFILES_BUILD_DIR/.tmux.conf" "$HOME/.tmux.conf" || error_log "failure to copy new .tmux.conf"

  backup_and_copy "$DOTFILES_BUILD_DIR/ghostty" "$HOME/.config/ghostty"

  backup_and_copy "$DOTFILES_BUILD_DIR/kitty" "$HOME/.config/kitty"
else
  warn_log "Skipping terminal setup (tmux, wezterm, ghostty)"
fi

# .config'd stuff
if [[ ! "$NO_NEOVIM" == "Y" ]]; then
  backup_and_copy "$DOTFILES_BUILD_DIR/nvim" "$HOME/.config/nvim"
else
  warn_log "Skipping neovim config setup"
fi

if [[ ! "$NO_HYPR" == "Y" ]]; then
  warn_log "No hypr config stuf to setup in this repo right now"
else
  warn_log "Skipping hyprland config setup"
fi

if [[ ! "$NO_OPENCODE" == "Y" ]]; then
  if [[ -d "$DOTFILES_BUILD_DIR/opencode" ]]; then
    backup_and_copy "$DOTFILES_BUILD_DIR/opencode" "$HOME/.config/opencode"
  else
    warn_log "Opencode config not found in repo, skipping install."
  fi
else
  warn_log "Skipping opencode config setup"
fi

happy_log "Finished install!"
