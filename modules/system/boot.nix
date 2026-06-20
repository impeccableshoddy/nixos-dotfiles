{...}: {
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
