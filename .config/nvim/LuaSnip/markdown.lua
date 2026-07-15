local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local yaml_header = s({},
    {
        t({ "---", "date: " }),
        f(function() return os.date("%Y-%m-%d") end, {}),
        t({ "", 'title: "' }), i(1),
        t({ '"', 'source: "' }), i(2),
        t({ '"', "tags:", "  - " }), i(3),
        t({ "", "---", "", "" }),
        i(0)
    }
)

local function is_nt()
    local basename = vim.fn.expand("%:t:r")
    return #basename == 14 and basename:match("^%d+$") ~= nil
end

local function is_new_file()
    return vim.fn.filereadable(vim.fn.expand("%:p")) == 0
end

local function expand_auto_header()
    if not is_nt() or not is_new_file() then
        return
    end
    vim.schedule(function()
        ls.snip_expand(yaml_header)
        vim.cmd("startinsert!")
    end)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = expand_auto_header,
})

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
