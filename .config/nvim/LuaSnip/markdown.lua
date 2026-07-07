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

local function expand_auto_header()
    local basename = vim.fn.expand("%:r")
    if #basename == 14 and not string.match(basename, "%D") then
        ls.add_snippets("markdown", { yaml_header })
        vim.schedule(function()
            ls.snip_expand(yaml_header)
            vim.cmd("startinsert!")
        end)
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = expand_auto_header,
})

return {
    s("link", {
        t("["),
        i(1, "text"),
        t("]("),
        f(function()
            return vim.fn.getreg('+'):gsub("%s+", "")
        end),
        t(")"),
    }),

    s("mathblock", {
        t({ "$$", "" }),
        i(1, "maths"),
        t({ "", "$$" }),
    }),

    s("mathinline", {
        t({ "$" }),
        i(1, "maths"),
        t({ "$ " }),
    }),
}
