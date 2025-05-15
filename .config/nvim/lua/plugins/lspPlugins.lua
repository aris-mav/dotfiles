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

                    vim.keymap.set("n", "<leader>r", vim.lsp.buf.references)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })

            -- Julia lsp config
            vim.lsp.config['julials'] = {
                -- Command and arguments to start the server.
                cmd = { '' },
                filetypes = { 'julia' },
                root_markers = { 'Project.toml', 'Manifest.toml' },

                settings = {
                    require'lspconfig'.julials.setup{
                        on_new_config = function(new_config, _)
                            local julia = vim.fn.expand("~/.julia/environments/lsp/")
                            if require'lspconfig'.util.path.is_file(julia) then
                                new_config.cmd[1] = julia
                            end
                        end
                    }
                }
            }


            -- Alternative, manual loading
            -- -- These are just examples. Replace them with the language
            -- -- servers you have installed in your system
            -- require('lspconfig').gleam.setup({})
            -- require('lspconfig').ocamllsp.setup({})
        end
    }
}
