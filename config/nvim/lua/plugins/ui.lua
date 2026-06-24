-- =============================================================================
-- dodona UI setup
-- Colorscheme is loaded from config/nvim/colors/dodona.vim (auto-discovered
-- via runtimepath prepend in modules/home/neovim.nix).
-- =============================================================================

vim.cmd.colorscheme("dodona")

-- Transparency overrides — keep terminal opacity (stylix 0.88) visible
-- through foot. dodona.vim already sets Normal guibg=NONE, but these ensure
-- any plugin that re-sets a bg gets reverted.
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.cmd("hi Directory guibg=NONE")

-- =============================================================================
-- Lualine — custom dodona theme
-- =============================================================================
local dodona_theme = {
  normal   = {
    a = { fg = "#222222", bg = "#ffa133" },            -- orange
    b = { fg = "#e8e8e8", bg = "#2a2a2a" },
    c = { fg = "#5a5a5a", bg = "#222222" }
  },
  insert   = {
    a = { fg = "#222222", bg = "#7ec0ff" },            -- blue (adding data)
    b = { fg = "#e8e8e8", bg = "#2a2a2a" },
    c = { fg = "#5a5a5a", bg = "#222222" }
  },
  visual   = {
    a = { fg = "#222222", bg = "#d2d2d2" },            -- bright gray (selecting)
    b = { fg = "#e8e8e8", bg = "#2a2a2a" },
    c = { fg = "#5a5a5a", bg = "#222222" }
  },
  replace  = {
    a = { fg = "#ffffff", bg = "#ff5a3c" },            -- red (destructive)
    b = { fg = "#e8e8e8", bg = "#2a2a2a" },
    c = { fg = "#5a5a5a", bg = "#222222" }
  },
  command  = {
    a = { fg = "#222222", bg = "#b4b4b4" },            -- high gray (command mode)
    b = { fg = "#e8e8e8", bg = "#2a2a2a" },
    c = { fg = "#5a5a5a", bg = "#222222" }
  },
  inactive = {
    a = { fg = "#5a5a5a", bg = "#222222" },
    b = { fg = "#5a5a5a", bg = "#222222" },
    c = { fg = "#5a5a5a", bg = "#222222" }
  },
}

require("lualine").setup({
  options = {
    theme = dodona_theme,
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

-- =============================================================================
-- Highlight colors (hex codes shown inline)
-- =============================================================================
require("nvim-highlight-colors").setup({})

-- =============================================================================
-- Indent blankline
-- =============================================================================
require("ibl").setup({
  indent = { char = "▏" },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
})

-- =============================================================================
-- Which-key
-- =============================================================================
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
