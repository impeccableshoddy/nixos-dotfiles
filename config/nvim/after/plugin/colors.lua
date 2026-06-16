local status, tokyonight = pcall(require, "tokyonight")
if not status then return end

local has_matugen, matugen = pcall(dofile, "/home/badmaster67/.cache/matugen/matugen_colors.lua")

tokyonight.setup({
    style = "moon",
    on_colors = function(colors)
        if has_matugen and type(matugen) == "table" then
            colors.bg      = matugen.bg
            colors.fg      = matugen.fg
            colors.red     = matugen.red
            colors.green   = matugen.green
            colors.yellow  = matugen.yellow
            colors.blue    = matugen.blue
            colors.magenta = matugen.magenta
            colors.cyan    = matugen.cyan
        else
            -- Your exact fallback values
            colors.bg      = "#080404"
            colors.fg      = "#f5efe6"
            colors.red     = "#e74c3c"
            colors.green   = "#82a870"
            colors.yellow  = "#d4924a"
            colors.blue    = "#7aa2c8"
            colors.magenta = "#aa7a9a"
            colors.cyan    = "#7aacac"
        end
        colors.bg_dark  = colors.bg
        colors.bg_float = colors.bg
        colors.comment  = "#625555"
    end,
})

vim.cmd.colorscheme("tokyonight")

-- Transparency overrides remain untouched
vim.cmd("hi Directory guibg=NONE")
vim.cmd("hi SignColumn guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
