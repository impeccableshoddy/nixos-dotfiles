local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

local ignore_patterns = {
  "%.cache/", "%.local/", "%.git/", "%.npm/", "%.cargo/",
  "node_modules/", "__pycache__/", "target/", "build/",
  "%.png", "%.jpg", "%.jpeg", "%.gif", "%.webp",
  "%.mp4", "%.mkv", "%.mp3", "%.flac", "%.wav",
  "%.pdf", "%.epub", "%.zip", "%.tar", "%.gz",
  "%.o$", "%.a$", "%.so", "%.out$",
  "Pictures/", "Videos/", "Books/",
  "mozilla/", "%.zen/", "%.steam/",
}

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },
    file_ignore_patterns = ignore_patterns,
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading",
      "--with-filename", "--line-number",
      "--column", "--smart-case", "--hidden",
      "--glob", "!.git/",
    },
  },
})
telescope.load_extension("fzf")

-- File finding
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fm", function()
  builtin.man_pages({ sections = { "ALL" } })
end, { desc = "Man pages" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix" })

-- Grep
vim.keymap.set("n", "<leader>fg", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep string" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "Live grep" })

-- Config files
vim.keymap.set("n", "<leader>fi", function()
  builtin.find_files({ cwd = "~/nixos-dotfiles/config/nvim/" })
end, { desc = "Find nvim config" })

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon next" })

-- Harpoon via telescope
vim.keymap.set("n", "<leader>fk", function()
  local conf = require("telescope.config").values
  local themes = require("telescope.themes")
  local file_paths = {}
  for _, item in ipairs(harpoon:list().items) do
    table.insert(file_paths, item.value)
  end
  require("telescope.pickers").new(themes.get_ivy({ prompt_title = "Harpoon" }), {
    finder    = require("telescope.finders").new_table({ results = file_paths }),
    previewer = conf.file_previewer({}),
    sorter    = conf.generic_sorter({}),
  }):find()
end, { desc = "Harpoon telescope" })
