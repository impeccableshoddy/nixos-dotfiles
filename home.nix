{ config, pkgs, pkgs-unstable, zen-browser, ... }:
let
  dotfiles = "/home/badmaster67/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.username = "badmaster67";
  home.homeDirectory = "/home/badmaster67";
  imports = [ 
  ./modules/neovim.nix 
  ];

  home.file = {
    ".config/mango".source = create_symlink "${dotfiles}/mango";
    ".config/foot".source = create_symlink "${dotfiles}/foot";
    ".config/waybar".source = create_symlink "${dotfiles}/waybar";
    ".config/nvim".source = create_symlink "${dotfiles}/nvim";
    ".config/dunst".source = create_symlink "${dotfiles}/dunst";
  };

  programs.git.enable = true;
  programs.foot.enable = true;
  programs.dircolors.enable = true;
  home.packages = with pkgs; [
    foot
    zen-browser
    yazi
    tmux
    fuzzel
    eza
    btop
    zoxide
    fastfetch
    dunst

    waybar
    playerctl
    bc
    swaybg

    blueman
    networkmanagerapplet

    libnotify
    wl-clipboard
    grim
    slurp
    wlsunset
    brightnessctl
    pamixer
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
