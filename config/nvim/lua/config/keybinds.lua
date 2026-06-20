vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = function(modes, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(modes, lhs, rhs, opts)
end

-- Escape
map("i", "jk", "<Esc>")
map("i", "<C-c>", "<Esc>")

-- File operations
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<C-q>", ":q!<CR>", { desc = "Force quit" })

-- File browser
map("n", "<leader>cd", vim.cmd.Ex, { desc = "Netrw" })

-- Reload config
map("n", "<leader>rl", function()
  dofile(vim.fn.expand("~/nixos-dotfiles/config/nvim/init.lua"))
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload config" })

-- Source current file
map("n", "<leader><leader>", "<cmd>so<CR>", { desc = "Source file" })

-- Search
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear highlights" })

-- Move lines in visual
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better join line
map("n", "J", "mzJ`z")

-- Centered scroll
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste without replacing clipboard
map("x", "<leader>p", [["_dP]], { desc = "Paste no yank" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete no yank" })

-- Disable Ex mode
map("n", "Q", "<nop>")

-- Window navigation (tmux-navigator handles these when in tmux)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Splits
map("n", "<C-]>", ":vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>-", ":split<CR>", { desc = "Split horizontal" })

-- Resize splits with arrows
map("n", "<Left>", ":vertical resize -2<CR>")
map("n", "<Right>", ":vertical resize +2<CR>")
map("n", "<Up>", ":resize -2<CR>")
map("n", "<Down>", ":resize +2<CR>")

-- Select all / select line
map({ "n", "v", "i" }, "<M-a>", "<Esc>ggVG", { desc = "Select all" })
map({ "n", "v", "i" }, "<M-l>", "<Esc>0V$", { desc = "Select line" })

-- Quickfix
map("n", "<C-j>", "<cmd>cnext<CR>zz")
map("n", "<C-k>", "<cmd>cprev<CR>zz")
map("n", "<leader>cl", ":cclose<CR>", { silent = true, desc = "Close quickfix" })
map("n", "<leader>co", ":copen<CR>", { silent = true, desc = "Open quickfix" })
map("n", "<leader>cn", ":cnext<CR>zz", { desc = "Next quickfix" })
map("n", "<leader>cp", ":cprev<CR>zz", { desc = "Prev quickfix" })

-- Location list
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Diagnostics
map("n", "<leader>x", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>z", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = "Toggle diagnostics" })

-- Undotree
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })

-- Replace word under cursor
map("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Replace word" })

-- Make executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

-- PHP format
map("n", "<leader>cc", "<cmd>!php-cs-fixer fix % --using-cache=no<cr>", { desc = "PHP format" })

-- LSP health
map("n", "<leader>li", ":checkhealth vim.lsp<CR>", { desc = "LSP info" })

-- C compile and run
map("n", "<leader>m", function()
  if vim.bo.filetype ~= "c" then
    vim.notify("Not a C file", vim.log.levels.WARN, { title = "Compile" })
    return
  end
  vim.cmd("write")
  local src = vim.fn.expand("%:p")
  local bin = vim.fn.expand("%:p:r")
  local cmd = { "gcc", "-Wall", "-Wextra", "-Wpedantic", "-g", "-O0", src, "-o", bin }
  local out = vim.fn.system(cmd)
  local code = vim.v.shell_error
  vim.fn.setqflist({}, "r")
  if out ~= "" then
    local lines = vim.split(out, "\n", { trimempty = true })
    vim.fn.setqflist({}, " ", { lines = lines, efm = vim.o.errorformat })
  end
  if code ~= 0 then
    vim.cmd("copen")
    vim.notify("Compilation failed", vim.log.levels.ERROR, { title = "Compile" })
  else
    vim.cmd("cclose")
    vim.notify("Compiled: " .. vim.fn.fnamemodify(bin, ":t"), vim.log.levels.INFO, { title = "Compile" })
  end
end, { desc = "Compile C file" })

map("n", "<leader>mr", function()
  if vim.bo.filetype ~= "c" then
    vim.notify("Run configured for C only", vim.log.levels.WARN, { title = "Run" })
    return
  end
  local bin = vim.fn.expand("%:p:r")
  if vim.fn.filereadable(bin) == 0 then
    vim.notify("Binary not found, compile first", vim.log.levels.ERROR, { title = "Run" })
    return
  end
  vim.cmd("botright split | resize 12 | terminal " .. vim.fn.fnameescape(bin))
  vim.cmd("startinsert")
end, { desc = "Run C binary" })

map("n", "<leader>mn", ":cn<CR>", { desc = "Next error" })
map("n", "<leader>mp", ":cp<CR>", { desc = "Prev error" })
map("n", "<leader>mo", ":copen<CR>", { desc = "Open quickfix" })
