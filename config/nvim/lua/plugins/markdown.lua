require("render-markdown").setup({
  enabled = true,
  render_modes = { "n", "c" },
  anti_conceal = { enabled = true },

  -- Headings: default icons are designed for overlay position
  -- 󰲡󰲣󰲥󰲧󰲩󰲫 replace the # marks, full-width colored backgrounds
  heading = {
    enabled = true,
    signs = true,
    position = "overlay",
    width = "full",
    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
  },

  -- Code blocks: full style with language icons (uses your nvim-web-devicons)
  code = {
    style = "full",
    left_pad = 2,
    right_pad = 2,
  },

  -- Pipe tables: rounded borders with alignment indicators
  pipe_table = {
    preset = "round",
    cell = "padded",
    style = "full",
  },

  -- Dash: visible horizontal rule
  dash = {
    icon = "─",
    width = 80,
  },

  -- Callouts: plugin ships with full GitHub + Obsidian defaults built in
  -- [!NOTE], [!TIP], [!WARNING], [!CAUTION], [!IMPORTANT]
  -- [!TODO], [!HINT], [!QUESTION], [!BUG], [!FAILURE], etc.
  -- All pre-configured with distinct icons + highlight colors

  -- Latex: inline + block rendering (needs latex TS parser + pylatexenc)
  latex = {
    enabled = true,
  },

  -- Completions for checkboxes and callouts via nvim-cmp
  completions = {
    lsp = { enabled = true },
  },
})

vim.keymap.set("n", "<leader>rm", ":RenderMarkdown toggle<CR>", { desc = "Toggle markdown render" })
