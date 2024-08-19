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

while [[ "$#" -gt 0 ]] do 
case $1 in
  --no-neovim) NO_NEOVIM="Y";;
  --no-hypr) NO_HYPR="Y";;
  --no-term) NO_TERM="Y";;
  *) error_log "Unknown argument passed: $1"
  exit 1;;
esac
shift
done

info_log "Syncing .config files!"

# tmux, wezterm
if [[ ! "$NO_TERM" == "Y" ]]; then
  cp .tmux.conf ~
  cp .wezterm.lua ~
else
  warn_log "Skipping terminal setup (tmux, wezterm)"
fi

# .config'd stuff
if [[ ! "$NO_NEOVIM" == "Y" ]]; then
  rm -r ~/.config/nvim
  cp -r "$DOTFILES_BUILD_DIR/nvim" ~/.config/
else
  warn_log "Skipping neovim config setup"
fi

if [[ ! "$NO_HYPR" == "Y" ]]; then
  rm -r ~/.config/hypr
  cp -r "$DOTFILES_BUILD_DIR/hypr" ~/.config/

  rm -r ~/.config/eww
  cp -r "$DOTFILES_BUILD_DIR/eww" ~/.config/

  # spin up the daemon if it hasn't already started
  if [[ ! `pidof eww` ]]; then
          ${EWW} daemon
          sleep 1
  fi

  is_bin_in_path eww && eww reload > /dev/null

  rm -r ~/.config/wofi
  cp -r "$DOTFILES_BUILD_DIR/wofi" ~/.config/

  rm -r ~/.config/mako/
  cp -r "$DOTFILES_BUILD_DIR/mako" ~/.config/
else
  warn_log "Skipping hyprland config setup"
fi

happy_log "Finished install!"
