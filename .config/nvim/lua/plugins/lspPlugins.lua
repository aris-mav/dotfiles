return {
    {
        -- Automatically install LSP servers with mason
        'williamboman/mason.nvim',
        lazy = false,
        opts = { },
    },

    {
        'neovim/nvim-lspconfig',
        cmd = {'LspInfo', 'LspInstall', 'LspStart'},
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
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

            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts)
                    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      opts)
                    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     opts)
                    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  opts)
                    vim.keymap.set("n", "go",         vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr",         vim.lsp.buf.references,      opts)
                    vim.keymap.set("n", "gs",         vim.lsp.buf.signature_help,  opts)
                    vim.keymap.set("n", "<C-s>",      vim.lsp.buf.signature_help,  opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts)
                    vim.keymap.set("n", "<leader>d",  vim.diagnostic.open_float,   opts)

                end,
            })

            -- Detect Termux
            local is_termux = os.getenv("PREFIX") and os.getenv("PREFIX"):match("com.termux")

            if not is_termux then
                require('mason-lspconfig').setup({
                    ensure_installed = {
                        "lua_ls",
                        "texlab",
                        "rust_analyzer",
                        "markdown_oxide"
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
