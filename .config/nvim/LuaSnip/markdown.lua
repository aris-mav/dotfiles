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
        t({"$$", ""}),
        i(1, "maths"),
        t({"", "$$"}),
    }),

    s("mathinline", {
        t({"$"}),
        i(1, "maths"),
        t({"$ "}),
    }),

}
