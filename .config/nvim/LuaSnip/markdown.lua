local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
    s("link", {
        t("["),
        i(1, "text"),
        t("]("),
        d(2, function()
            local clipboard = vim.fn.getreg('+'):gsub("%s+", "")
            if clipboard == "" then
                clipboard = "url"
            end
            return sn(nil, {
                i(1, clipboard)
            })
        end, {}),
        t(")"),
    }),

    s("mathblock", {
        t({ "$$", "" }),
        i(1, "maths"),
        t({ "", "$$", "" }),
    }),

    s("mathinline", {
        t({ "$" }),
        i(1, "maths"),
        t({ "$ " }),
    }),
}
