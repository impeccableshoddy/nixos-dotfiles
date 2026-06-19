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
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = ["imv.desktop"];
      "image/png" = ["imv.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "video/webm" = ["mpv.desktop"];
      "inode/directory" = ["thunar.desktop"];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "impeccableshoddy";
      user.email = "227250706+impeccableshoddy@users.noreply.github.com";
    };
  };
  programs.dircolors.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "FiraCode Nerd Font Mono:size=12";
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

  programs.yazi = {
    enable = true;
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

  programs.zoxide = {
  enable = true;
  enableBashIntegration = true;
};

  programs.fzf = {
  enable = true;
  enableBashIntegration = true;
};

  programs.starship = {
  enable = true;
  settings = lib.mkForce {
    add_newline = true;
    command_timeout = 1000;

    palette = "girl";
    palettes.girl = {
      ink      = "#090910"; # deepest navy
      graphite = "#13141C"; # dark navy, unused divider color, kept for future use
      slate    = "#1A1B28"; # dark cool navy — lang/tool pill backgrounds
      rose     = "#BB8181"; # medium rose — directory bg
      taupe    = "#CD8F90"; # light rose — git bg
      blush    = "#F1B0B4"; # lightest pink — bright text on dark bg
      cream    = "#9F7274"; # muted mauve, unused, kept for future use
      deepred  = "#B83549"; # deep mauve — cmd_duration / error state
    };

    format = lib.concatStrings [
      "[](ink)"                  # LEFT cap (e0b6), opens the bar
      "$hostname"
      "[](fg:ink bg:rose)"       # RIGHT cap (e0b4), ink -> rose transition
      "$directory"
      "[](fg:rose bg:taupe)"     # RIGHT cap (e0b4), rose -> taupe transition
      "$git_branch"
      "$git_status"
      "[](fg:taupe)"             # RIGHT cap (e0b4), closes the bar on taupe
      "$nix_shell"
      "$docker_context"
      "$c"
      "$cpp"
      "$rust"
      "$golang"
      "$zig"
      "$lua"
      "$perl"
      "$nodejs"
      "$python"
      "$line_break"
      "$character"
    ];

    hostname = {
      ssh_only = false;
      style = "bg:ink fg:blush";
      format = "[ $hostname ]($style)";
      disabled = false;
    };

    directory = {
      style = "fg:ink bg:rose";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncate_to_repo = true;
    };

    git_branch = {
      symbol = " ";
      style = "fg:ink bg:taupe";
      format = "[ $symbol$branch ]($style)";
    };

    git_status = {
      style = "fg:ink bg:taupe";
      format = "[($all_status$ahead_behind )]($style)";
    };

    # Self-contained pills: LEFT cap (e0b6) + content + RIGHT cap (e0b4).
    nix_shell      = { symbol = "❄"; style = "fg:blush bg:slate"; format = "[ $symbol $name ]($style)[](fg:slate)"; };
    docker_context = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $context ]($style)[](fg:slate)"; only_with_files = true; };
    c              = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    cpp            = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    rust           = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    golang         = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    zig            = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    lua            = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    perl           = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    nodejs         = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };
    python         = { symbol = "";  style = "fg:blush bg:slate"; format = "[ $symbol $version ]($style)[](fg:slate)"; };

    line_break.disabled = false;

    character = {
      success_symbol = "[╰─](bold fg:blush)";
      error_symbol = "[╰─](bold fg:deepred)";
    };
  };
};

  programs.zathura = {
    enable = true;
    package = pkgs.zathura.override {
    plugins = [
      pkgs.zathuraPkgs.zathura_cb
    ];
  };
  };

  programs.btop.enable = true;

  home.packages = with pkgs; [
    fd
    ncdu
    imv
    mpv
    file-roller
    unzip
    p7zip
    bemoji
    ripgrep
    fastfetch
    legcord
    libreoffice-fresh
    gimp
    aseprite
    inkscape
    wf-recorder
    kdePackages.ghostwriter
    zen-browser
    fuzzel
    libnotify
    grim
    slurp
    swappy
    cliphist
    wl-clipboard
    awww
    playerctl
    pulsemixer
    brightnessctl
    bluetui
    impala
    bc
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      nrb = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oubliette-btw";
      nup = "nix flake update --flake ~/nixos-dotfiles && sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oubliette-btw";
      y = "yazi";
    };
  };

  home.stateVersion = "26.05";
}
