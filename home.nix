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
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g mouse on
      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on

      set -g status-position top
      set -g status-interval 5
      set -g status-left-length 40
      set -g status-right-length 100

      set -g window-status-format " #I:#W "
      set -g window-status-current-format " #I:#W* "

      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      bind | split-window -h
      bind - split-window -v
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
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
