return {
    {
        -- Automatically install LSP servers with mason
        'williamboman/mason.nvim',
        event = "VeryLazy",
        opts = {},
    },

    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        init = function()
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'no'
        end,
        config = function()
            local lsp_defaults = require('lspconfig').util.default_config

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- Detect Termux
            local is_termux = os.getenv("PREFIX") and os.getenv("PREFIX"):match("com.termux")

            if not is_termux then
                require('mason-lspconfig').setup({
                    ensure_installed = {
                        "lua_ls",
                        "texlab",
                        "rust_analyzer",
                        "marksman",
                        "ruff", "ty",
                    },
                    handlers = {
                        function(server_name)
                            vim.lsp.enable(server_name)
                        end,
                    }
                })
            end

            -- enable fish lsp
            vim.lsp.enable('fish_lsp')
        end
    }
}
