{hostname, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrb = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#${hostname}";
      nup = "nix flake update --flake ~/nixos-dotfiles && sudo nixos-rebuild switch --flake ~/nixos-dotfiles#${hostname}";
      y = "yazi";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.dircolors.enable = true;
  programs.btop.enable = true;
}
