return {

  s("link", {
    t("["),
    i(1, "text"),
    t("]("),
    i(2, "url"),
    t(")"),
  }),

  s("eqn", {
    t("$$ "),
    i(1, "text"),
    t(" $$"),
  }),

}
