local has_base16, base16 = pcall(require, "base16")
if has_base16 then
    local ok, palette = pcall(require, "stylix_palette")
    if ok then
        -- Apply Stylix palette via base16-nvim
        base16(palette, true)
        
        -- Transparency overrides
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
        vim.cmd("hi Directory guibg=NONE")
        vim.cmd("hi SignColumn guibg=NONE")
        return
    end
end

-- Fallback: tokyonight moon with catppuccin-mocha-ish colors
local status, tokyonight = pcall(require, "tokyonight")
if not status then return end

tokyonight.setup({
    style = "moon",
    transparent = true,
    on_colors = function(colors)
        colors.bg       = "#1e1e2e"
        colors.fg       = "#cdd6f4"
        colors.red      = "#f38ba8"
        colors.green    = "#a6e3a1"
        colors.yellow   = "#f9e2af"
        colors.blue     = "#89b4fa"
        colors.magenta  = "#cba6f7"
        colors.cyan     = "#94e2d5"
        colors.bg_dark  = "#1e1e2e"
        colors.bg_float = "#1e1e2e"
        colors.comment  = "#6c7086"
    end,
})

vim.cmd.colorscheme("tokyonight")

-- Transparency overrides
vim.cmd("hi Directory guibg=NONE")
vim.cmd("hi SignColumn guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
