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
        config = function()
            vim.lsp.config('bashls', {
                settings = {
                    bashIde = {
                        shellcheckPath =
                            vim.fn.stdpath('data') .. '/mason/bin/shellcheck',
                    },
                },
            })
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {},
    },
}
