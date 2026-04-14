return {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    version = "v2.*",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    config = function()

        local ls = require("luasnip")

        ls.filetype_extend("tex", { "math" })
        ls.filetype_extend("markdown", { "math" })

        require("luasnip.loaders.from_lua").lazy_load(
            {paths = "~/.config/nvim/LuaSnip/"}
        )

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
            local snip = ls.session.current_nodes[vim.api.nvim_get_current_buf()].parent.snippet
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
            if ls.in_snippet() then
                untrigger()
                ls.unlink_current()
            end
        end, { desc = "Undo a snippet", })

    end,
}
