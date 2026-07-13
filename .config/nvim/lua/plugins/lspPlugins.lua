return {
    {
        -- Automatically install LSP servers with mason
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

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

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
