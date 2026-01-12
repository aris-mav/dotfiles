return { -- these are meant to be shared between tex and md files

    s(
        {
            trig="upright",
            dscr="Latex mathrm for non-italic symbols in equations",
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
    )

}
