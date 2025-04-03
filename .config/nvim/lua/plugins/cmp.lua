return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup({
            sources = {
                {name = 'nvim_lsp'},
                {name = 'path' },
                {name = 'buffer', keyword_length = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Space>'] = cmp.mapping.confirm({ select = false }), -- select false is so that it does not auto select the 1st sugggestion
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            }),
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
        })
    end
}
