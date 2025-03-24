{ pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.placidfireball = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */

    home.packages = [
      pkgs.zsh-powerlevel10k
    ];

    programs.tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.yank
	tmuxPlugins.catppuccin
      ];
      extraConfig = ''
# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Set prefix to c-space
unbind C-b
set -g prefix C-space
bind C-space send-prefix

# mouse mode on
set -g mouse on
# status bar on top
set -g status-position top 
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# -- nvim/tmux pane navigation --
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
# -- </ntim/tmux pane navigation --

bind-key -n M-H previous-window
bind-key -n M-L next-window

bind-key -n C-t new-window
bind-key -n C-T kill-window

# -- begin catpuccin --
set -g @plugin 'catppuccin/tmux#latest'
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_battery}"
      '';
    };

    programs.zsh = {
     enable = true;
     enableCompletion = true;
     autosuggestion.enable = true;
     syntaxHighlighting.enable = true;

     history.size = 40000;

     initExtraFirst = "source ~/.p10k.zsh";

     plugins = [
       {
         name = "zsh-powerlevel10k";
	 src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
	 file = "powerlevel10k.zsh-theme";
       }
     ];

     oh-my-zsh = {
      enable = true;
      plugins = ["z" "git" "tmux" "sudo"];
     };
    };
    
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.wezterm = {
      enable = true;
    };

    programs.kitty = {
      enable = true;
      settings = {
      	fontFamily = "JetBrains Mono";
	bold_font = "auto";
	italic_font = "auto";
	bold_italic_font = "auto";

	font_size = 12.0;
      };
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''

      '';
    };
  };
}
