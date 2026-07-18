return {
    {
        'williamboman/mason.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {
            ensure_installed = {
                'fish_lsp',
                'markdown_oxide',
                'ruff', 'ty',
                'lua_ls',
                'bashls',
            },
        },
    },
}
