-- add yaml header automatically on nt files
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    once = true,
    callback = function()
        local basename = vim.fn.expand("%:r")

        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local f = ls.function_node
        local i = ls.insert_node

        local yaml_header = s({ trig = "frontmatter" }, {
            t({ "---", "date: " }),
            f(function() return os.date("%Y-%m-%d") end, {}),
            t({ "", 'title: "' }), i(1),
            t({ '"', 'source: "' }), i(2),
            t({ '"', "tags:", "  - " }), i(3),
            t({ "", "---", "", "" }),
            i(0)
        })

        if #basename == 14 and not string.match(basename, "%D") then
            vim.schedule(function()
                -- (Snippet definition here)
                ls.snip_expand(yaml_header)
                vim.cmd("startinsert!")
            end)
        end
    end,
})
