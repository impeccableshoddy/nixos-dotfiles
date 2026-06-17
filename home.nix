{ config, lib, pkgs, pkgs-unstable, zen-browser, ... }:
let
  dotfiles = "/home/badmaster67/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.username = "badmaster67";
  home.homeDirectory = "/home/badmaster67";
  imports = [ ./modules/neovim.nix ];

  home.file = {
    ".config/mango".source = create_symlink "${dotfiles}/mango";
    ".config/btop".source = create_symlink "${dotfiles}/btop";
  };

  programs.git.enable = true;
  programs.dircolors.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "CommitMono Nerd Font Mono:size=13:fontfeatures=calt=1,liga=1";
        pad = "4x4";
        initial-window-size-chars = "90x25";
      };
      "key-bindings" = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        scrollback-up-line = "Shift+Up";
        scrollback-down-line = "Shift+Down";
        search-start = "Control+Shift+r";
        font-increase = "Control+equal";
        font-decrease = "Control+minus";
        font-reset = "Control+0";
      };
      "search-bindings" = {
        cancel = "Escape";
        commit = "Return";
        find-prev = "Control+r";
        find-next = "Control+s";
      };
    };
  };

 programs.tmux = {
  enable = true;
  plugins = with pkgs.tmuxPlugins; [
    vim-tmux-navigator  # handles the smart nvim/tmux pane switching
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
    set -g status-right " #{pane_current_command}  %H:%M "
    set -g window-status-format " #I:#W "
    set -g window-status-current-format " #I:#W "
    set -g status-style "bg=default"
    set -g window-status-current-style "bold"
    set -g message-style "bg=default,bold"

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

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-size = 2;
      border-radius = 8;
      padding = "10";
      margin = "10";
      icons = true;
      max-icon-size = 48;
      anchor = "top-right";
      width = 350;
      height = 150;
    };
  };

  home.packages = with pkgs; [
    zoxide
    eza
    fastfetch
    yazi
    kdePackages.ghostwriter
    zen-browser
    fuzzel
    libnotify
    grim
    slurp
    swappy
    wl-clipboard
    awww
    playerctl
    pamixer
    brightnessctl
    bluetui
    bc
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      nrb = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oubliette-btw";
      ll = "eza -lah --icons=auto --color=always --group-directories-first";
      tree = "eza --tree --icons=auto --color=always";
    };
  };

  home.stateVersion = "26.05";
}
