local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Filetype-specific indent (2 spaces)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "html", "css", "lua", "nix" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes:1"
opt.cursorline = true
opt.colorcolumn = ""
opt.scrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.showmode = true
opt.cmdheight = 1

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Backspace
opt.backspace = "indent,eol,start"

-- Word definition
opt.iskeyword:append("-")

-- Undo / swap
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
opt.undofile = true

-- Performance
opt.updatetime = 50
opt.mouse = "a"

-- Spell
opt.spell = true
opt.spelllang = { "en_us" }

-- Sessions
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

-- Error format
opt.errorformat = table.concat({
    "%f:%l:%c: %t%*[^:]: %m",
    "%f:%l: %t%*[^:]: %m",
    "%f:%l:%c: %m",
    "%f:%l: %m",
}, ",")

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "»",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})

-- Create undodir if missing
vim.fn.mkdir(os.getenv("HOME") .. "/.local/share/nvim/undodir", "p")
