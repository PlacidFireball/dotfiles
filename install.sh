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

echo "Syncing .config files whether you like it or not... TODO: conditional syncs"

# tmux, wezterm
cp .tmux.conf ~
cp .wezterm.lua ~

# .config'd stuff
rm -r ~/.config/nvim
cp -r "$DOTFILES_BUILD_DIR/nvim" ~/.config/

rm -r ~/.config/hypr
cp -r "$DOTFILES_BUILD_DIR/hypr" ~/.config/

rm -r ~/.config/eww
cp -r "$DOTFILES_BUILD_DIR/eww" ~/.config/

is_bin_in_path eww && eww reload

rm -r ~/.config/wofi
cp -r "$DOTFILES_BUILD_DIR/wofi" ~/.config/

rm -r ~/.config/mako/
cp -r "$DOTFILES_BUILD_DIR/mako" ~/.config/

# rm -r ~/.config/gBar
# cp -r gBar ~/.config/

echo "Finished the sync - rejoice and be glad!"
