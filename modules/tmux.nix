{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g mouse on
      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on

          # --- Status bar ---
      set -g status-position top
      set -g status-interval 5
      set -g status-left-length 20
      set -g status-right-length 60
      set -g status-left " #S "
      set -g status-right " %d-%b %H:%M "
      set -g window-status-format " #I:#W "
      set -g window-status-current-format " #I:#W "

      # --- Splits ---
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # --- Window switching with Alt ---
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-h previous-window
      bind -n M-l next-window
      bind -n M-n new-window

      # --- Smart pane switching (works with vim-tmux-navigator in nvim) ---
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

      # --- Resize ---
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # --- Misc ---
      set -g history-limit 10000
      set -g escape-time 0
      set -g focus-events on
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"
      bind x kill-pane
      bind q kill-window
    '';
  };
}
