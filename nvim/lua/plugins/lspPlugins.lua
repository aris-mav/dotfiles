return {
    {
        'mason-org/mason.nvim',
        cmd = 'Mason',
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
        'mason-org/mason-lspconfig.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'mason-org/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {},
    },
}
