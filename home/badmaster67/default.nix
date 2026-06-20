{username, ...}: {
  imports = [
    ./packages.nix
    ./shell.nix
    ./wayland.nix
    ./programs
    ../../modules/home/neovim.nix
    ../../modules/home/tmux.nix
    ../../modules/home/starship.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
}
