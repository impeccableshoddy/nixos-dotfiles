# Dev shell for dodona development.
# `nix develop` from the repo root enters this shell.
{ pkgs ? import <nixpkgs> {} }:

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
}
