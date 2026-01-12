return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    config = function()

        local ls = require("luasnip")
        local cmp = require("cmp")

        require("luasnip").filetype_extend("tex", { "math" })
        require("luasnip").filetype_extend("markdown", { "math" })

        require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})

        vim.cmd[[ 
        " Use Tab to expand and jump through snippets
        imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
        smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
        " Use Shift-Tab to jump backwards through snippets
        imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
        smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>' ]]

        -- also define another expand keybind, in case cmp is triggered as well
        vim.keymap.set({"i"}, "<C-L>", function()
            ls.expand()
        end, {silent = true})

        vim.keymap.set({"i", "s"}, "<C-E>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, {silent = true})

        ls.config.set_config({ -- Setting LuaSnip config
            -- Enable autotriggered snippets
            enable_autosnippets = true,
            -- Use Tab (or some other key if you prefer) to trigger visual selection
            store_selection_keys = "<Tab>",
        })

        local untrigger = function() --courtesy of https://github.com/L3MON4D3/LuaSnip/issues/797#issuecomment-1970013181
            -- get the snippet
            local snip = require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()].parent.snippet
            -- get its trigger
            local trig = snip.trigger
            -- replace that region with the trigger
            local node_from, node_to = snip.mark:pos_begin_end_raw()
            vim.api.nvim_buf_set_text(
                0,
                node_from[1],
                node_from[2],
                node_to[1],
                node_to[2],
                { trig }
            )
            -- reset the cursor-position to ahead the trigger
            vim.fn.setpos(".", { 0, node_from[1] + 1, node_from[2] + 1 + string.len(trig) })
        end

        vim.keymap.set({ "i", "s" }, "<c-z>", function()
            if require("luasnip").in_snippet() then
                untrigger()
                require("luasnip").unlink_current()
            end
        end, { desc = "Undo a snippet", })


        cmp.setup({
            -- ... Your other configuration ...
            mapping = {
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
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif ls.locally_jumpable(1) then
                        ls.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif ls.locally_jumpable(-1) then
                        ls.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                -- ... Your other mappings ...

            },
            -- ... Your other configuration ...
        })
    end,
}
