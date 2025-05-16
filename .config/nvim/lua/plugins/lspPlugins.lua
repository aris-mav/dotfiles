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
                        vim.lsp.enable(server_name)
                    end,
                }
            })

            -- Julia lsp config
            vim.lsp.config('julials', {
                cmd = {
                    "julia",
                    "--project=".."~/.julia/environments/lsp/",
                    "--startup-file=no",
                    "--history-file=no",
                    "-e", [[
                        using Pkg
                        Pkg.instantiate()
                        using LanguageServer
                    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
                    project_path = let
                        dirname(something(
                            ## 1. Finds an explicitly set project (JULIA_PROJECT)
                            Base.load_path_expand((
                                p = get(ENV, "JULIA_PROJECT", nothing);
                                    p === nothing ? nothing : isempty(p) ? nothing : p
                                )),
                                    ## 2. Look for a Project.toml file in the current working directory,
                                    ##    or parent directories, with $HOME as an upper boundary
                                    Base.current_project(),
                                    ## 3. First entry in the load path
                                    get(Base.load_path(), 1, nothing),
                                    ## 4. Fallback to default global environment,
                                    ##    this is more or less unreachable
                                Base.load_path_expand("@v#.#"),
                            ))
                        end
                                @info "Running language server" VERSION pwd() project_path depot_path
                                server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
                    server.runlinter = true
                        run(server)
                    ]]
                },
                filetypes = { 'julia' },
                root_markers = { "Project.toml", "JuliaProject.toml" },
                settings = {}
            })

        end
    }
}
