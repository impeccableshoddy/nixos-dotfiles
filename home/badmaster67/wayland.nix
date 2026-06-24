{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  dotfiles = "/home/${username}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in {
  home.file.".config/mango".source = create_symlink "${dotfiles}/mango";

  services.mako = {
    enable = true;
    settings = {
      font = lib.mkForce "CommitMono Nerd Font 13";
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
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    wf-recorder
    wl-mirror
    fuzzel
    libnotify
    playerctl
    brightnessctl
    wayfreeze
    awww
    pulsemixer
  ];
}
