{ config, pkgs, lib, ... }:

let
  nvimDir = "/home/badmaster67/nixos-dotfiles/config/nvim";
in
{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    lua-language-server
    nil
    nixpkgs-fmt
    nodejs
    gcc
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      base16-nvim
      telescope-nvim
      plenary-nvim
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      harpoon
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      nvim-lspconfig
    ];

    initLua = ''
      -- Add repo to runtimepath so lua/, after/, plugin/, parser/, queries/ are found
      vim.opt.rtp:prepend("${nvimDir}")
      vim.opt.rtp:append("${nvimDir}/after")

      -- Load user's init.lua
      dofile("${nvimDir}/init.lua")
    '';
  };

  # Disable Stylix's automatic nvim theming — we'll handle it manually
  stylix.targets.neovim.enable = false;

  # Inject Stylix palette as a lua module
  home.file.".config/nvim/lua/stylix_palette.lua".text = ''
    return {
      base00 = "#${config.lib.stylix.colors.base00}",
      base01 = "#${config.lib.stylix.colors.base01}",
      base02 = "#${config.lib.stylix.colors.base02}",
      base03 = "#${config.lib.stylix.colors.base03}",
      base04 = "#${config.lib.stylix.colors.base04}",
      base05 = "#${config.lib.stylix.colors.base05}",
      base06 = "#${config.lib.stylix.colors.base06}",
      base07 = "#${config.lib.stylix.colors.base07}",
      base08 = "#${config.lib.stylix.colors.base08}",
      base09 = "#${config.lib.stylix.colors.base09}",
      base0A = "#${config.lib.stylix.colors.base0A}",
      base0B = "#${config.lib.stylix.colors.base0B}",
      base0C = "#${config.lib.stylix.colors.base0C}",
      base0D = "#${config.lib.stylix.colors.base0D}",
      base0E = "#${config.lib.stylix.colors.base0E}",
      base0F = "#${config.lib.stylix.colors.base0F}",
    }
  '';
}
