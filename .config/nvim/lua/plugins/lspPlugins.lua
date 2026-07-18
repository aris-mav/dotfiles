return {
    {
        'williamboman/mason.nvim',
        event = "VeryLazy",
        opts = {},
        dependencies = {
            { 'williamboman/mason-lspconfig.nvim' },
        },
    },

    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lsp_defaults = require('lspconfig').util.default_config

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    function(server_name)
                        vim.lsp.enable(server_name)
                    end,
                }
            })

            -- enable fish lsp
            vim.lsp.enable('fish_lsp')
        end
    }
}
