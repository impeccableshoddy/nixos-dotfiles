{lib, ...}: {
  stylix = {
    enable = true;
    image = null;
    polarity = "dark";
    autoEnable = true;

    base16Scheme = {
      scheme = "Phosphor Dodona";
      author = "badmaster67";
      base00 = "222222";
      base01 = "2a2a2a";
      base02 = "333333";
      base03 = "5a5a5a";
      base04 = "888888";
      base05 = "d4d4d4";
      base06 = "ededed";
      base07 = "ffffff";
      base08 = "ffa133";
      base09 = "ffa133";
      base0A = "ffa133";
      base0B = "d4d4d4";
      base0C = "ffa133";
      base0D = "ffa133";
      base0E = "ffd84d";
      base0F = "5a5a5a";
    };

    targets.limine.enable = false;

    fonts = {
      monospace.name = "CommitMono Nerd Font";
      sansSerif.name = "Work Sans";
      serif.name = "EB Garamond";
      sizes = {
        terminal = 13;
        applications = 13;
        desktop = 13;
        popups = 13;
      };
    };

    opacity = {
      terminal = 0.88;
      applications = 0.88;
      desktop = 0.88;
      popups = 0.92;
    };
  };

  # Boot console (kernel fbcon + systemd). Top-level NixOS option, NOT stylix.*.
  # Stylix's console target auto-writes this from base16Scheme; we mkForce to
  # override so [ OK ] shows in accent (#ffa133) without re-theming editor strings.
  # Slots: 0=black 1=red 2=green 3=yellow 4=blue 5=magenta 6=cyan 7=gray
  #        8-15 = bright variants of the above
  console.colors = lib.mkForce [
    "222222" # 0  black
    "ff5a3c" # 1  red          → critical
    "ffa133" # 2  green        → ACCENT (systemd [ OK ] uses this)
    "ffd84d" # 3  yellow       → warning
    "ffa133" # 4  blue         → accent
    "ff2e88" # 5  magenta      → alarm
    "ffa133" # 6  cyan         → accent
    "d4d4d4" # 7  gray         → default fg
    "5a5a5a" # 8  bright-black → dim
    "ff5a3c" # 9  bright-red
    "ffa133" # 10 bright-green
    "ffd84d" # 11 bright-yellow
    "ffa133" # 12 bright-blue
    "ff2e88" # 13 bright-magenta
    "ffa133" # 14 bright-cyan
    "ffffff" # 15 bright-white
  ];
}
