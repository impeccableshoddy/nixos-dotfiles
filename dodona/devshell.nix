# Dev shell for dodona development.
#
# `nix develop` from the repo root enters this shell.
# Returns a mkShell derivation with the Rust toolchain + all native deps
# needed to `cargo build` dodona.
#
# Why no fenix input: nixpkgs' rust toolchain is fine for development and
# avoids adding a flake input. If you need a specific Rust version pinned
# or nightly features, swap the `cargo`/`rustc`/etc. lines for
# `fenix.packages.${system}.stable.completeToolchain` and add fenix to
# flake.nix inputs.
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    # Rust toolchain (stable, from nixpkgs)
    cargo
    rustc
    clippy
    rustfmt
    rust-analyzer

    # Native libs that dodona links against (or that its crates need
    # at link time via system-dep). mkShell's `packages` puts them on
    # PATH and sets up PKG_CONFIG_PATH for pkg-config to find.
    pkg-config
    wayland
    wayland-protocols
    libxkbcommon
    fontconfig
    freetype

    # Nice-to-haves
    gdb # debugging panics with `run` then `bt full`
  ];

  # rust-analyzer needs rust-src for go-to-definition on std/core/alloc.
  # rustPlatform.rustLibSrc is the nixpkgs-provided rust-src tarball.
  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  # Sensible defaults for `cargo run` without prefixing env vars.
  RUST_LOG = "dodona=debug,info";
  RUST_BACKTRACE = "1";

  # Helps cosmic-text's fontconfig find configs in pure shells.
  # Without this, fontconfig can still find system fonts via the default
  # /etc/fonts/fonts.conf — but explicit is safer.
  FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
}
