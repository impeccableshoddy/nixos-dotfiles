{ config, lib, pkgs, pkgs-unstable, zen-browser, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Calcutta";

  networking.hostName = "oubliette-btw";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.openssh.enable = true;
  services.vnstat.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.getty.autologinUser = "badmaster67";
  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec mango
  '';

  programs.mango.enable = true;

  users.users.badmaster67 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  # --- Stylix theming ---
  stylix = {
    enable = true;
    image = builtins.path { path = ./wallpapers/girl.jpg; name = "wallpaper"; };
    polarity = "dark";
    # Auto-extract colors from example.jpg instead of static scheme
    # This gives colors that actually match the wallpaper
    autoEnable = true;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
      serif = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
      sizes = {
        terminal = 13;
        applications = 11;
        desktop = 10;
        popups = 10;
      };
    };

    opacity = {
      terminal = 0.87;
      applications = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
  ];

  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
nix.settings.auto-optimise-store = true;

  fonts.packages = with pkgs; [
    iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.commit-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  hardware.graphics.enable = true;
  system.stateVersion = "26.05";
}
