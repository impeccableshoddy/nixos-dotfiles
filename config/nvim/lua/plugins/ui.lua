-- Catppuccin
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  integrations = {
    treesitter = true,
    telescope = { enabled = true },
    harpoon = true,
    gitsigns = true,
    which_key = true,
    indent_blankline = { enabled = true },
    mini = { enabled = true },
    lsp_trouble = false,
    cmp = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
  },
})
vim.cmd.colorscheme("catppuccin")

-- Transparency overrides
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.cmd("hi Directory guibg=NONE")

-- Lualine
require("lualine").setup({
  options = {
    theme = "catppuccin-mocha",
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      "diagnostics",
      {
        function()
          local reg = vim.fn.reg_recording()
          if reg == "" then return "" end
          return "󰑊 @" .. reg
        end,
      },
    },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Highlight colors (hex codes shown inline)
require("nvim-highlight-colors").setup({})

-- Indent blankline
require("ibl").setup({
  indent = { char = "▏" },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
})

-- Which-key
require("which-key").setup({
  delay = 100,
  icons = { mappings = false },
  spec = {
    { "<leader>m", group = "make/compile" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>c", group = "code" },
  },
})
