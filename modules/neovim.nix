{
  config,
  pkgs,
  lib,
  ...
}: let
  nvimDir = "/home/badmaster67/nixos-dotfiles/config/nvim";
in {
  home.packages = with pkgs; [
    # LSP servers
    lua-language-server
    nil
    alejandra
    nodejs
    gcc
    typescript-language-server
    vscode-langservers-extracted # cssls, htmlls, jsonls
    rust-analyzer
    gopls
    zls

    # Formatters
    stylua
    nixpkgs-fmt
    black
    prettierd
    rustfmt

    # Tools
    ripgrep
    fd
    fzf
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      # Core
      plenary-nvim
      nvim-web-devicons
      vim-tmux-navigator

      # Navigation
      telescope-nvim
      telescope-fzf-native-nvim
      harpoon2

      # Treesitter
      nvim-treesitter.withAllGrammars

      # LSP + Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Formatting
      conform-nvim
      vim-easy-align

      # Editor utilities
      mini-nvim # covers mini.ai and mini.surround both
      nvim-autopairs
      vim-matchup
      nvim-highlight-colors
      indent-blankline-nvim

      # Git
      vim-fugitive
      gitsigns-nvim

      # UI
      lualine-nvim
      catppuccin-nvim
      undotree

      # Tools
      vim-visual-multi
      which-key-nvim
    ];

    initLua = ''
      vim.opt.rtp:prepend("${nvimDir}")
      vim.opt.rtp:append("${nvimDir}/after")
      dofile("${nvimDir}/init.lua")
    '';
  };

  stylix.targets.neovim.enable = false;
}
