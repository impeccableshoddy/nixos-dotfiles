{ config, lib, pkgs, pkgs-unstable, zen-browser, ... }:
let
  dotfiles = "/home/badmaster67/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.username = "badmaster67";
  home.homeDirectory = "/home/badmaster67";
  imports = [ 
    ./modules/neovim.nix 
    ./modules/tmux.nix
    ./modules/starship.nix
  ];

  home.file = {
    ".config/mango".source = create_symlink "${dotfiles}/mango";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Images
      "image/jpeg" = ["imv.desktop"];
      "image/png" = ["imv.desktop"];
      "image/gif" = ["imv.desktop"];
      "image/webp" = ["imv.desktop"];
      
      # Video & Audio
      "video/mp4" = ["mpv.desktop"];
      "video/webm" = ["mpv.desktop"];
      "audio/*" = ["mpv.desktop"];
      
      # Documents & Comics (THIS IS WHAT YOU WERE MISSING)
      "application/pdf" = ["zathura.desktop"];
      "application/x-cbz" = ["zathura.desktop"];
      "application/x-cbr" = ["zathura.desktop"];
      "application/x-cb7" = ["zathura.desktop"];
      "application/epub+zip" = ["mupdf.desktop"];
      
      # Folders
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

  programs.zathura = {
    enable = true;
    package = pkgs.zathura.override {
    plugins = [
      pkgs.zathuraPkgs.zathura_cb
      pkgs.zathuraPkgs.zathura_pdf_poppler
    ];
  };
  };

  programs.btop.enable = true;

  home.packages = with pkgs; [
    file
    fd
    ncdu
    imv
    mpv
    file-roller
    unzip
    p7zip
    bemoji
    mupdf
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
