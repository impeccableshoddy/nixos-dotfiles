# Dev shell for dodona development.
# `nix develop` from the repo root enters this shell.
{pkgs ? import <nixpkgs> {}}: let
  # The nerd-fonts packages already installed in the system (fonts.nix).
  # We reference them here so build.rs can find the font files in the
  # nix store instead of downloading them at build time.
  departureMonoPkg = pkgs.nerd-fonts.departure-mono;
  commitMonoPkg = pkgs.nerd-fonts.commit-mono;
in
  pkgs.mkShell {
    packages = with pkgs; [
      # Rust toolchain (stable, from nixpkgs)
      cargo
      rustc
      clippy
      rustfmt
      rust-analyzer

      # Build-time tooling
      pkg-config

      # curl — used by build.rs to auto-download fonts if not found in nix store.
      # (Only needed on first build outside Nix; inside nix develop the fonts
      # come from the nix store via the env vars below.)
      curl

      # Wayland stack (smithay-client-toolkit + wayland-client)
      wayland
      wayland-protocols

      # Input (xkbcommon-rs, pulled by sctk for keyboard handling)
      libxkbcommon

      # Text rendering (cosmic-text → fontdb → fontconfig → freetype)
      fontconfig
      freetype

      # Audio (rodio → cpal → alsa-sys). alsa-lib provides alsa.pc + libasound.so.
      alsa-lib

      # Nice-to-have
      gdb
    ];

    # rust-analyzer needs rust-src for go-to-definition on std/core/alloc.
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

    # Sensible defaults for `cargo run`.
    RUST_LOG = "dodona=debug,info";
    RUST_BACKTRACE = "1";

    # Explicit fontconfig path — safer in pure shells.
    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

    # ---------------------------------------------------------------------------
    # Font paths for build.rs
    # ---------------------------------------------------------------------------
    # build.rs checks these env vars first when provisioning fonts to OUT_DIR.
    # The nerd-fonts packages install OTF/TTF files to share/fonts/ under the
    # nix store path. We pass the whole fonts directory so build.rs can search
    # for the exact filename (which varies between Nerd Font versions).
    #
    # If you change the font packages in fonts.nix, update the references here.
    # ---------------------------------------------------------------------------

    DODONA_NIX_FONTS_DIR = "${departureMonoPkg}/share/fonts";

    # Also set individual font paths as a more direct fallback.
    # These search for any file matching the font name + "Regular" in the package.
    DEPARTURE_MONO_PATH = let
      # Find the DepartureMono Regular OTF in the nerd-fonts package.
      # nix evaluates this at build time, so the path is resolved statically.
      fontDir = "${departureMonoPkg}/share/fonts";
    in "${fontDir}";

    COMMIT_MONO_PATH = let
      fontDir = "${commitMonoPkg}/share/fonts";
    in "${fontDir}";
  }
