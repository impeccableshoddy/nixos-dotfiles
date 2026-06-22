-- Fugitive (no setup needed, just commands like :G)

-- Conform formatting
vim.g.autoformat = false

require("conform").setup({
  format_on_save = function()
    if not vim.g.autoformat then
      return nil
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    python = { "black" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    html = { "prettierd" },
    css = { "prettierd" },
    rust = { "rustfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
  formatters = {
    ["clang-format"] = {
      prepend_args = {
        "--style={IndentWidth: 4, UseTab: Never, ColumnLimit: 100}",
      },
    },
  },
})
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })

vim.keymap.set("v", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format selection" })

vim.keymap.set("n", "<leader>ct", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(
    "Autoformat on save: " .. (vim.g.autoformat and "ON" or "OFF"),
    vim.log.levels.INFO,
    { title = "Format" }
  )
end, { desc = "Toggle autoformat" })

-- vim-visual-multi has no setup, works out of the box
-- Easy align
vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy align" })
