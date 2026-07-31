local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local function text_before_trigger(line_to_cursor)
    -- strip off the "mm" itself
    return line_to_cursor:sub(1, -3)
end

local function is_blank(str)
    -- check if string is empty (whitespaces allowed)
    return str:match("^%s*$") ~= nil
end

local function is_isolated_line()
    local cur = vim.api.nvim_win_get_cursor(0)
    local row = cur[1] -- 1-indexed current line
    if row <= 1 then
        return true    -- no line above, treat as isolated
    end
    local above = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] or ""
    return is_blank(above)
end

return {
    s({
        trig = "mm",
        snippetType = "autosnippet",
        condition = function(line_to_cursor)
            local before = text_before_trigger(line_to_cursor)
            if not is_blank(before) then
                return true -- text right before "mm" -> definitely inline
            end
            return not is_isolated_line()
        end,
    }, {
        t("$"), i(1), t("$ "),
    }),

    s({
        trig = "mm",
        snippetType = "autosnippet",
        condition = function(line_to_cursor)
            local before = text_before_trigger(line_to_cursor)
            return is_blank(before) and is_isolated_line()
        end,
    }, {
        t({ "$$", "" }), i(1), t({ "", "$$" }),
    }),

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

    s("footnote", {
        t({ "[^" }),
        i(1, ""),
        t({ "]: " }),
    }),

    s("source", {
        t({ "Source: " }),
        i(1, ""),
    }),
}
