return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'saadparwaiz1/cmp_luasnip',
        'f3fora/cmp-spell',
        'micangl/cmp-vimtex',
    },
    config = function()
        local cmp = require('cmp')
        local ls = require('luasnip')
        local menu_icon = {
            nvim_lsp = "",
            luasnip  = "󰩫",
            buffer   = "󰧮",
            path     = "",
            spell    = "󰓆",
            vimtex   = "",
        }

        local symbol_map = {
            Text = "󱌴 text",
            Variable = "𝛘 var ",
            Function = "󰊕 func",
            Struct = "󰙅 stru",
            Field = "󰜢 fld ",
            Class = "󰠱 clas",
            Method = "󰆧 mthd",
            Constructor = " cons",
            Interface = " intf",
            Module = " modu",
            Property = "󰜢 prop",
            Unit = "󰑭 unit",
            Value = "󰎠 valu",
            Enum = " enum",
            Keyword = "󰌋 keyw",
            Snippet = " snip",
            Color = "󰏘 colr",
            File = "󰈙 file",
            Reference = "󰈇 refr",
            Folder = "󰉋 dir ",
            EnumMember = " memb",
            Constant = "󰏿 cnst",
            Event = " evnt",
            Operator = "󰆕 oper",
            TypeParameter = "󰉿 type",
        }


        cmp.setup({

            disallow_fuzzy_matching = false,
            preselect = cmp.PreselectMode.None,
            formatting = {
                fields = {
                    "abbr",
                    "kind",
                    "menu",
                },
                format = function(entry, item)
                    item.menu = menu_icon[entry.source.name] or entry.source.name
                    item.kind = symbol_map[item.kind] or item.kind

                    local win_width = vim.api.nvim_win_get_width(0)

                    local max_content_width
                    if win_width < 100 then
                        max_content_width = math.floor(win_width * 0.5)
                    else
                        max_content_width = 50
                    end

                    if #item.abbr > max_content_width then
                        -- cut the string short to prevent window from getting too long
                        item.abbr = vim.fn.strcharpart(item.abbr, 0, max_content_width - 3) .. "..."
                    else
                        -- pad with spaces so that window is always the same size
                        -- item.abbr = content .. (" "):rep(max_content_width - #content)
                    end

                    return item
                end,
            },

            sources = {
                { name = 'nvim_lsp' },
                { name = 'vimtex' },
                { name = 'path' },
                { name = 'luasnip' },
                { name = 'buffer',  keyword_length = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4, { 'i', 'c' }),
                ['<C-d>'] = cmp.mapping.scroll_docs(4, { 'i', 'c' }),
                ['<Space>'] = cmp.mapping.confirm({ select = false }, { 'i', 'c' }), -- select false is so that it does not auto select the 1st sugggestion

                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if ls.expandable() then
                            ls.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if ls.locally_jumpable(1) then
                        ls.jump(1)
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if ls.locally_jumpable(-1) then
                        ls.jump(-1)
                    elseif cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

            }),

            snippet = {
                expand = function(args)
                    -- vim.snippet.expand(args.body)
                    ls.lsp_expand(args.body)
                end,
            },

        })
        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            }),
            formatting = {
                format = function(entry, vim_item)
                    -- Add menu info to show source
                    vim_item.menu = ({
                        path = "[Path]",
                        cmdline = "[Cmd]"
                    })[entry.source.name]

                    -- Optional: add kind label
                    vim_item.kind = "" -- Icon for shell/command

                    return vim_item
                end
            }
        })
        -- `/` cmdline setup.
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- f3fora/cmp-spell' setup
        cmp.setup.filetype(
            { 'markdown', 'latex', 'gitcommit', 'text' },
            {
                sources = cmp.config.sources({
                    { name = 'luasnip',  priority = 1000 },
                    { name = 'nvim_lsp', priority = 750 },
                    { name = 'path',     priority = 500 },
                }, {
                    { name = 'buffer', keyword_length = 3 },
                    {
                        name = 'spell',
                        priority = 250,
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return require('cmp.config.context').in_treesitter_capture('spell')
                            end,
                        },
                    },
                })
            })
    end
}
