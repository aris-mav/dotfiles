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


        -- Tab to expand or jump
        vim.keymap.set({"i", "s"}, "<Tab>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
        end, {silent = true})

        -- Shift-Tab to jump backwards
        vim.keymap.set({"i", "s"}, "<S-Tab>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, {silent = true})

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
