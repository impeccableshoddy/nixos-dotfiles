# nixos-dotfiles

NixOS 26.05 configuration for a single machine. Managed entirely through flakes — no mutable state outside `/nix/store` (except the Mango WM config, which is symlinked for live editing).

## Structure

```
.
├── flake.nix                        # Flake inputs & outputs
├── flake.lock
├── wallpapers/
├── hosts/
│   └── oubliette-btw/               # Machine-specific NixOS config
│       ├── default.nix
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system/                      # NixOS system modules
│   │   ├── boot.nix                 # Bootloader (Limine), swap, GC
│   │   ├── desktop-mango.nix        # Mango WM, Thunar, autologin
│   │   ├── fonts.nix                # Fonts & cursor
│   │   ├── networking.nix           # NetworkManager, iwd, firewall, DNS
│   │   ├── services.nix             # keyd, Bluetooth, backlight
│   │   ├── stylix.nix               # Base theme (color generation from wallpaper)
│   │   └── users.nix
│   └── home/                        # Home-manager modules
│       ├── neovim.nix               # Neovim plugins & LSP servers
│       ├── starship.nix             # Prompt
│       └── tmux.nix                 # Tmux + vim-tmux-navigator
└── home/
    └── badmaster67/
        ├── default.nix              # Home-manager entry point
        ├── packages.nix             # User packages
        ├── shell.nix                # Bash, fzf, zoxide
        ├── wayland.nix              # Mako, screenshot/recording tools, Mango symlink
        └── programs/
            ├── foot.nix             # Terminal emulator
            ├── git.nix
            ├── yazi.nix             # File manager
            └── zathura.nix          # PDF reader
```

## Window Manager

[Mango](https://github.com/mangowm/mango) — a tiling Wayland compositor. Config lives at `config/mango/config.conf` and is symlinked into `~/.config/mango` so edits take effect on reload (`Super+r`).

Keybind groups: core launches (`Super+Return/Space/e/c/w/s`), tag management (`Super+1-9`, `Super+Shift+1-9`), layout switching (`Super+t/v/x`), window focus (`Super+h/j/k/l`), swap (`Super+Shift+h/j/k/l`), and media keys. See `config.conf` for the full map.

## Editor

Neovim with Lua config, LSP for 14 languages, and Conform formatting. See [`config/nvim/README.md`](config/nvim/README.md) for keybinds and plugin details.

## Apply

```sh
# Rebuild
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oubliette-btw

# Update flake inputs + rebuild
nix flake update --flake ~/nixos-dotfiles && sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oubliette-btw
```

Shell aliases `nrb` and `nup` are provided for these.

## Inputs

| Input | Purpose |
|---|---|
| nixpkgs (nixos-26.05) | System packages |
| nixpkgs-unstable | Unstable overlay (allowUnfree) |
| home-manager | User package management |
| stylix | Color generation from wallpaper |
| mango | Window manager |
| zen-browser | Browser |
