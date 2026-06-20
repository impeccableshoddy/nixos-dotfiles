-- Treesitter
require("nvim-treesitter").setup({
    highlight = { enable = true },
    indent = { enable = true },
})

-- mini.ai — better text objects (yip, yiq, yia etc)
require("mini.ai").setup()

-- mini.surround — ys/ds/cs operations
require("mini.surround").setup()

-- Autopairs
require("nvim-autopairs").setup({})

-- Matchup — brace/block jumping and highlighting
vim.g.matchup_matchparen_offscreen = { method = "popup" }

-- Gitsigns
require("gitsigns").setup({
    signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", gs.next_hunk, "Next hunk")
        map("n", "[c", gs.prev_hunk,  "Prev hunk")
        map("n", "<leader>gs", gs.stage_hunk,   "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk,   "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.blame_line,   "Blame line")
    end,
})
