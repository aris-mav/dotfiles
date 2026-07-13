local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

-- taken from https://github.com/frankroeder/dotfiles/blob/657a5dc559e9ff526facc2e74f9cc07a1875cac6/nvim/lua/tsutils.lua#L59
local has_treesitter, ts = pcall(require, "vim.treesitter")
-- local _, query = pcall(require, "vim.treesitter.query")

local MATH_ENVIRONMENTS = {
    displaymath = true,
    equation = true,
    eqnarray = true,
    align = true,
    math = true,
    array = true,
}

local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
}

local function get_node_at_cursor()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(ts.get_parser, buf, "latex")
    if not ok or not parser then
        return
    end
    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then
        return
    end

    return root:named_descendant_for_range(
        cursor_range[1],
        cursor_range[2],
        cursor_range[1],
        cursor_range[2]
    )
end

local function is_in_math()
    if has_treesitter then
        local buf = vim.api.nvim_get_current_buf()
        local node = get_node_at_cursor()
        while node do
            if MATH_NODES[node:type()] then
                return true
            elseif node:type() == "math_environment"
                or node:type() == "generic_environment" then
                local begin = node:child(0)
                local names = begin and begin:field "name"
                if names
                    and names[1]
                    and MATH_ENVIRONMENTS[
                    vim.treesitter.get_node_text(names[1], buf):match "[A-Za-z]+"
                    ]
                then
                    return true
                end
            end
            node = node:parent()
        end
        return false
    end
end

-- Dynamic matrices
-- from https://evesdropper.dev/files/luasnip/choice-dynamic/
local mat = function(args, snip)
    local rows = tonumber(snip.captures[2])
    local cols = tonumber(snip.captures[3])
    local nodes = {}
    local ins_indx = 1
    for j = 1, rows do
        table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
        ins_indx = ins_indx + 1
        for k = 2, cols do
            table.insert(nodes, t(" & "))
            table.insert(
                nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1))
            )
            ins_indx = ins_indx + 1
        end
        table.insert(nodes, t({ " \\\\", "" }))
    end
    -- fix last node.
    nodes[#nodes] = t(" \\\\")
    return sn(nil, nodes)
end

local snippets = { -- these are meant to be shared between tex and md files

    -- Dynamic matrices
    -- from https://evesdropper.dev/files/luasnip/choice-dynamic/
    s({
            trig = "([bBpvV])mat(%d+)x(%d+)([ar])",
            regTrig = true,
            name = "matrix",
            hidden = false
        },
        fmt([[
        \begin{<>}<>
        <>
        \end{<>}]],
            { f(function(_, snip)
                return snip.captures[1] .. "matrix" -- captures matrix type
            end),
                f(function(_, snip)
                    if snip.captures[4] == "a" then
                        local out = string.rep(
                            "c", tonumber(snip.captures[3]) - 1
                        ) -- array for augment
                        return "[" .. out .. "|c]"
                    end
                    return "" -- otherwise return nothing
                end),
                d(1, mat),
                f(function(_, snip)
                    return snip.captures[1] .. "matrix" -- i think i could probably use a repeat node but whatever
                end), },
            { delimiters = "<>" })
    ),

    s({ trig = "^", dscr = "exponent", snippetType = "autosnippet" }, {
        t("^{"),
        i(1, "exponent"),
        t("}")
    }),

    s({ trig = "normm", dscr = "Norm with _{}^{}" }, {
        t("\\left\\lVert "),
        i(1, "symbol"),
        t(" \\right\\rVert_{"),
        i(2, ""),
        t("}^{"),
        i(3, ""),
        t("}")
    }),

    s({ trig = "braket", dscr = "Bra-Ket (Inner Product)" }, {
        t("\\left\\langle "),
        i(1, "left"),
        t(" \\middle| "),
        i(2, "right"),
        t(" \\right\\rangle")
    }),

    s({ trig = "braaket", dscr = "Expectation Value" }, {
        t("\\left\\langle "),
        i(1, "left"),
        t(" \\middle| "),
        i(2, "middle"),
        t(" \\middle| "),
        i(3, "right"),
        t(" \\right\\rangle")
    }),

    s({ trig = "frac", dscr = "Latex fraction", }, {
        t("\\frac{"),
        i(1, "num"),
        t("}{"),
        i(2, "den"),
        t("}"),
    }),

    s({
        trig = "derivative",
        dscr = "Leibnitz notation for 1st monovariate derivative",
    }, {
        t("\\frac{\\mathrm{d}{"),
        i(1, ""),
        t("}}{\\mathrm{d}{"),
        i(2, "x"),
        t("}}"),
    }),

    s({
        trig = "derivative_partial",
        dscr = "Leibnitz notation for partial derivative",
    }, {
        t("\\frac{\\partial{"),
        i(1, ""),
        t("}}{\\partial{"),
        i(2, "x"),
        t("}}"),
    }),

    s({ trig = "differential", dscr = "Differential of a variable", }, {
        t("\\frac{\\mathrm{d}{"), i(1, ""), t("}"),
    }),

    s({ trig = "differential_partial", dscr = "Partial differential of a variable", }, {
        t("\\frac{\\partial{"), i(1, ""), t("}"),
    }),

    s({ trig = "integral_evaluated", dscr = "Evaluated bounded integral", }, {
        t("\\left["),
        i(1, "function"),
        t(" \\right]_{"),
        i(2, "lo"),
        t("}^{"),
        i(3, "up"),
        t("}"),
    }),

    s({ trig = "sum", }, {
        t("\\sum_{"),
        i(1, "lo"),
        t("}^{"),
        i(2, "up"),
        t("}{"),
        i(3, "content"),
        t("}")
    }),

    s({
        trig = "underset", dscr = "place text under some other text",
    }, {
        t("\\underset{"),
        i(1, "under"),
        t("}{"),
        i(2, "over"),
        t("}")
    }),

    s({ trig = "log", dscr = "logarithm of any base", }, {
        t("\\log_{"),
        i(1, "base"),
        t("}\\left({"),
        i(2, "argument"),
        t("}\\right)")
    }),

    s({ trig = "Rightarrow" }, { t("\\Rightarrow ") }),
    s({ trig = "rightarrow" }, { t("\\rightarrow ") }),
    s({ trig = "times" }, { t("\\times ") }),
    s({ trig = "cdot" }, { t("\\cdot ") }),
    s({ trig = "infty" }, { t("\\infty ") }),
}

for key, symbol in pairs({
    real     = "R",
    natural  = "N",
    complex  = "C",
    integer  = "Z",
    rational = "Q"
}) do
    table.insert(snippets, s("is" .. key, t("\\in\\mathbb{" .. symbol .. "}")))
end

for key, symbol in pairs({
    integral               = "int",
    integral_closed        = "oint",
    integral_double        = "iint",
    integral_double_closed = "oiint",
    integral_triple        = "iiint",
    integral_triple_closed = "oiiint",
}) do
    table.insert(snippets, s({ trig = key, dscr = "Bounded integral", }, {
        t("\\" .. symbol .. "_{"),
        i(1, "lo"), t("}^{"),
        i(2, "up"), t("}{"),
        i(3, "func"), t("}{\\mathrm{d}"),
        i(4, "var"), t("}")
    }))
end

for key, symbol in pairs({
    normal     = "mathnormal",
    bold       = "mathbf",
    upright    = "mathrm",
    italic     = "mathit",
    typewriter = "mathtt",
    sansserif  = "mathsf",
    cal        = "mathcal",
    bb         = "mathbb",
    ol         = "overline",
    ul         = "underline",
    hat        = "hat",
    dot        = "dot",
    vec        = "vec",
    nabla      = "nabla",
}) do
    table.insert(snippets, s({ trig = key }, {
        t("\\" .. symbol .. "{"),
        i(1, ""),
        t("}")
    }))
end

for _, symbol in pairs({
    "exp", "ln", "log", "sqrt",
    "sin", "cos", "tan",
    "asin", "acos", "atan",
    "sinh", "cosh", "tanh",
}) do
    table.insert(snippets, s({ trig = symbol }, {
        t("\\" .. symbol .. "{"), i(1, ""), t("}"),
    }))
end

local greek_letters = {
    "alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta",
    "iota", "kappa", "lambda", "mu", "nu", "xi", "pi", "rho",
    "sigma", "tau", "upsilon", "phi", "chi", "psi", "omega",
    "varepsilon", "varrho", "vartheta", "varphi",
    "Gamma", "Delta", "Theta", "Lambda",
    "Xi", "Pi", "Sigma", "Upsilon",
    "Phi", "Psi", "Omega",
}
for _, letter in ipairs(greek_letters) do
    table.insert(snippets, s({ trig = letter }, { t("\\" .. letter), })
    )
end

for key, symbols in pairs({
    par  = { "\\left( ", " \\right)", "parentheses" },
    sbr  = { "\\left[ ", " \\right]", "square brackets" },
    cbr  = { "\\left\\{ ", " \\right\\}", "curly braces" },
    abs  = { "\\left| ", " \\right|", "absolute value" },
    abr  = { "\\left\\langle ", " \\right\\rangle", "angle brackets" },
    flo  = { "\\left\\lfloor ", " \\right\\rfloor", "floor" },
    cei  = { "\\left\\lceil ", " \\right\\rceil", "ceiling" },
    norm = { "\\left\\lVert ", " \\right\\rVert", "norm" },
    bra  = { "\\left\\langle ", " \\right|", "bra" },
    ket  = { "\\left| ", " \\right\\rangle", "ket" },
}) do
    table.insert(snippets, s({ trig = key, dscr = symbols[3] }, {
        t(symbols[1]),
        i(1, "contents"),
        t(symbols[2])
    }))
end

for _, snip in ipairs(snippets) do
    snip.show_condition = is_in_math
    snip.condition = is_in_math
end

return snippets
