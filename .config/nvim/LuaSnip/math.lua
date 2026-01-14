local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return { -- these are meant to be shared between tex and md files

    s(
        {
            trig="upright",
            dscr="non-italic symbols in equations",
        },
        {
            t("\\mathrm{"),
            i(1, "symbol"),
            t("}"),
        }
    ),

    s(
        {
            trig="frac",
            descr="Latex fraction"
        },
        {
            t("\\frac{"),
            i(1, "numerator"),
            t("}{"),
            i(2, "denominator"),
            t("}"),
        }
    ),

    s(
        {
            trig="derivative",
            descr="Leibnitz notation for 1st monovariate derivative"
        },
        {
            t("\\frac{\\mathrm{d} "),
            i(1, "f"),
            t(" }{\\mathrm{d} "),
            i(2, "x"),
            t(" }"),
        }
    ),

    s(
        {
            trig="integral",
            descr="Bounded integral"
        },
        {
            t("\\int_{"),
            i(1, ""),
            t("}^{"),
            i(2, ""),
            t("}{"),
            i(3, ""),
            t("}{\\mathrm{d}"),
            i(4, ""),
            t("}")
        }
    ),

    s(
        {
            trig="underset",
            descr="place text in first {} under text in second {}"
        },
        {
            t("\\underset{"),
            i(1, ""),
            t("}{"),
            i(2, ""),
            t("}")
        }
    ),
}
