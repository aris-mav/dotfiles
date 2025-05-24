return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup({

            disallow_fuzzy_matching = false,
            preselect = cmp.PreselectMode.None,
            -- formatting taken from https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-5727678
            formatting = {
                fields = { "abbr", "menu", "kind" },
                format = function(entry, item)
                    -- Define menu shorthand for different completion sources.
                    local menu_icon = {
                        nvim_lsp = "LSP",
                        nvim_lua = "LUA",
                        luasnip  = "SNP",
                        buffer   = "BUF",
                        path     = "PTH",
                    }
                    -- Set the menu "icon" to the shorthand for each completion source.
                    item.menu = menu_icon[entry.source.name]

                    -- Set the fixed width of the completion menu 
                    -- local fixed_width = 25
                    local fixed_width = false

                    -- Get the completion entry text shown in the completion window.
                    local content = item.abbr

                    -- Set the fixed completion window width.
                    if fixed_width then
                        vim.o.pumwidth = fixed_width
                    end

                    -- Get the width of the current window.
                    local win_width = vim.api.nvim_win_get_width(0)

                    -- Set the max content width based on either: 'fixed_width'
                    -- or a percentage of the window width, in this case 20%.
                    -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
                    local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

                    -- Truncate the completion entry text if it's longer than the
                    -- max content width. We subtract 3 from the max content width
                    -- to account for the "..." that will be appended to it.
                    if #content > max_content_width then
                        item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
                    else
                        item.abbr = content .. (" "):rep(max_content_width - #content)
                    end
                    return item
                end,
            },

            sources = {
                {name = 'nvim_lsp'},
                {name = 'path' },
                {name = 'luasnip' },
                {name = 'buffer', keyword_length = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4 ,{ 'i', 'c' }),
                ['<C-d>'] = cmp.mapping.scroll_docs(4 ,{ 'i', 'c' }),
                ['<CR>'] = cmp.mapping.confirm({ select = true } ,{ 'i', 'c' }),
                ['<Space>'] = cmp.mapping.confirm({ select = false } ,{ 'i', 'c' }), -- select false is so that it does not auto select the 1st sugggestion
                ['<Tab>'] = cmp.mapping.select_next_item( { 'i', 'c' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item( { 'i', 'c' }),
            }),
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
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
    end
}
