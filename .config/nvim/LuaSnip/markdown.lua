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

    s("eqn", {
        t("$$ "),
        i(1, "maths"),
        t(" $$"),
    }),


}
