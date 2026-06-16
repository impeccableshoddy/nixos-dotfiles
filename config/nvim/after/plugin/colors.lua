local status, tokyonight = pcall(require, "tokyonight")
if not status then return end

tokyonight.setup({
    style = "moon",
    on_colors = function(colors)
        colors.bg       = "#080404" -- Near pitch-black crimson hue
        colors.bg_dark  = "#050202"
        colors.bg_float = "#100909"

        -- High-contrast text foreground
        colors.fg       = "#f5efe6" -- Crisper, brighter cream

        -- Swapped to your palette's 'bright' tokens for high-contrast syntax
        colors.red      = "#e74c3c"
        colors.green    = "#82a870"
        colors.yellow   = "#d4924a"
        colors.blue     = "#7aa2c8"
        colors.magenta  = "#aa7a9a"
        colors.cyan     = "#7aacac"

        -- Clean, visible but distinct comments
        colors.comment  = "#625555"
    end,
})

-- Load the theme
vim.cmd.colorscheme("tokyonight")

-- Your original transparency overrides
vim.cmd("hi Directory guibg=NONE")
vim.cmd("hi SignColumn guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
