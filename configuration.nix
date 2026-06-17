{ config, lib, pkgs, pkgs-unstable, zen-browser, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    maxGenerations = 10;
  };

  time.timeZone = "Asia/Calcutta";
  networking.hostName = "oubliette-btw";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.acpilight.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };

  services.openssh.enable = true;
  services.vnstat.enable = true;

  services.getty.autologinUser = "badmaster67";
  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec mango
  '';

  programs.mango.enable = true;

  home-manager.users.badmaster67.home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024;
  }];

  users.users.badmaster67 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager" "video" ];
  };

  stylix = {
    enable = true;
    image = builtins.path { path = ./wallpapers/girl.jpg; name = "wallpaper"; };
    polarity = "dark";
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
        applications = 13;
        desktop = 13;
        popups = 13;
      };
    };
    opacity = {
      terminal = 0.81;
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
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
