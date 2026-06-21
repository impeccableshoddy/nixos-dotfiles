{
  config,
  username,
  ...
}: {
  home.file.".config/fastfetch/config.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink
    "/home/${username}/nixos-dotfiles/config/fastfetch/config.jsonc";
}
