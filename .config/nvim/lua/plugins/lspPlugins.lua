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
                    local opts = {buffer = event.buf}

                    vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
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

            -- Julia lsp config
            vim.lsp.config('julials', {
                cmd = {
                    "julia",
                    "--project=".."~/.julia/environments/lsp/",
                    "--startup-file=no",
                    "--history-file=no",
                    vim.fn.expand("~/.config/nvim/lua/lsp/") .. "julials_start.jl"
                },
                filetypes = { 'julia' },
                root_markers = { "Project.toml", "JuliaProject.toml" },
                settings = {}
            })

        end
    }
}
