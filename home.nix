{ config, pkgs, pkgs-unstable, zen-browser, inputs, ... }:
let
  dotfiles = "/home/badmaster67/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.username = "badmaster67";
  home.homeDirectory = "/home/badmaster67";
  imports = [ 
  ./modules/neovim.nix 
  inputs.ags.homeManagerModules.default
  ];

  home.file = {
    ".config/mango".source = create_symlink "${dotfiles}/mango";
    ".config/foot".source = create_symlink "${dotfiles}/foot";
    ".config/waybar".source = create_symlink "${dotfiles}/waybar";
    ".config/nvim".source = create_symlink "${dotfiles}/nvim";
    ".config/ags".source = create_symlink "${dotfiles}/ags";
  };

  programs.ags = {
  enable = true;
  extraPackages = with inputs.astal.packages.${pkgs.system}; [
    io
    battery
    network
    tray
    mpris
    notifd
    wireplumber
    wl
    bluetooth
    brightness
    powerprofiles
  ];
};  

  programs.git.enable = true;
  home.packages = with pkgs; [
    foot
    zen-browser
    yazi
    tmux
    fuzzel

    zoxide
    fastfetch
    swaynotificationcenter
    waybar
    playerctl
    bc
    swaybg

    blueman
    networkmanagerapplet

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
    };
  };
  
  home.stateVersion = "26.05";
}
