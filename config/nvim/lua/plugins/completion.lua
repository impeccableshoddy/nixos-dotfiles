local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    preselect = cmp.PreselectMode.Item,
    completion = {
        completeopt = "menu,menuone,noinsert",
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion    = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
        ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
    }),
})
