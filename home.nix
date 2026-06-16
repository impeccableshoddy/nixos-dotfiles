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
    ".config/dunst".source = create_symlink "${dotfiles}/dunst";
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
    swayosd
    vnstat

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
