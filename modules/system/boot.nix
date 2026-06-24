{...}: {
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;

    # Manual theme — stylix's limine target is disabled in stylix.nix.
    # All colors are RRGGBB (no '#'). Empty wallpapers list = solid backdrop only.
    style = {
      wallpapers = [];
      wallpaperStyle = "stretched";
      backdrop = "222222";

      interface = {
        branding = "DODONA";
        brandingColor = "ffa133"; # title color
        helpColor = "ffa133"; # keybind hints
        helpColorBright = "ffd84d"; # auto-boot countdown digit
      };

      graphicalTerminal = {
        font = {
          scale = "2x2";
          spacing = 1;
        };
        background = "222222";
        foreground = "d4d4d4";
        brightBackground = "d4d4d4";
        brightForeground = "ffa133";
        # palette format: black;red;green;brown;blue;magenta;cyan;gray (8 entries, ;-separated)
        # Phosphor mapping: keep mono, only state-class colors diverge from orange.
        palette =
          "222222"
          + ";"
          + # black  → bg
          "ff5a3c"
          + ";"
          + # red    → critical
          "ffa133"
          + ";"
          + # green  → accent (reused for ok states)
          "ffd84d"
          + ";"
          + # brown  → warning
          "ffa133"
          + ";"
          + # blue   → accent
          "ff2e88"
          + ";"
          + # magenta→ alarm
          "ffa133"
          + ";"
          + # cyan   → accent
          "888888"; # gray   → mid
        brightPalette =
          "5a5a5a"
          + ";"
          + # dark gray
          "ff5a3c"
          + ";"
          + # bright red
          "ffa133"
          + ";"
          + # bright green (= accent)
          "ffd84d"
          + ";"
          + # bright yellow
          "ffa133"
          + ";"
          + # bright blue
          "ff2e88"
          + ";"
          + # bright magenta
          "ffa133"
          + ";"
          + # bright cyan
          "d4d4d4"; # white  → fg
      };
    };
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
