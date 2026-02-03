local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- taken from https://github.com/frankroeder/dotfiles/blob/657a5dc559e9ff526facc2e74f9cc07a1875cac6/nvim/lua/tsutils.lua#L59
local has_treesitter, ts = pcall(require, "vim.treesitter")
local _, query = pcall(require, "vim.treesitter.query")

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
      elseif node:type() == "math_environment" or node:type() == "generic_environment" then
        local begin = node:child(0)
        local names = begin and begin:field "name"
        if
          names
          and names[1]
          and MATH_ENVIRONMENTS[vim.treesitter.get_node_text(names[1], buf):match "[A-Za-z]+"]
        then
          return true
        end
      end
      node = node:parent()
    end
    return false
  end
end

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
            table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
            ins_indx = ins_indx + 1
        end
        table.insert(nodes, t({ " \\\\", "" }))
    end
    -- fix last node.
    nodes[#nodes] = t(" \\\\")
    return sn(nil, nodes)
end

local snippets = { -- these are meant to be shared between tex and md files

    -- from https://evesdropper.dev/files/luasnip/choice-dynamic/
    s({ trig = "([bBpvV])mat(%d+)x(%d+)([ar])", regTrig = true, name = "matrix", dscr = "matrix trigger lets go", hidden = true },
        fmt([[
    \begin{<>}<>
    <>
    \end{<>}]],
            {f(function(_, snip)
                return snip.captures[1] .. "matrix" -- captures matrix type
            end),
                f(function(_, snip)
                    if snip.captures[4] == "a" then
                        out = string.rep("c", tonumber(snip.captures[3]) - 1) -- array for augment 
                        return "[" .. out .. "|c]"
                    end
                    return "" -- otherwise return nothing
                end),
                d(1, mat),
                f(function(_, snip)
                    return snip.captures[1] .. "matrix" -- i think i could probably use a repeat node but whatever
                end),},
            { delimiters = "<>" })
    ),

    s(
        {
            trig="norm",
        },
        {
            t("\\lVert "),
            i(1, "symbol"),
            t(" \\rVert ")
        }
    ),

    s(
        {
            trig="normm",
        },
        {
            t("\\lVert "),
            i(1, "symbol"),
            t(" \\rVert_{"),
            i(2, ""),
            t("}^{"),
            i(3, ""),
            t("}")
        }
    ),

    s(
        {
            trig="vec",
        },
        {
            t("\\vec{"),
            i(1, "symbol"),
            t("}"),
        }
    ),

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
            descr="Latex fraction",
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
            descr="Leibnitz notation for 1st monovariate derivative",
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
            descr="Bounded integral",
        },
        {
            t("\\int_{"),
            i(1, "lower"),
            t("}^{"),
            i(2, "upper"),
            t("}{"),
            i(3, "function"),
            t("}{\\mathrm{d}"),
            i(4, "variable"),
            t("}")
        }
    ),

    s(
        {
            trig="sum",
        },
        {
            t("\\sum_{"),
            i(1, "lower"),
            t("}^{"),
            i(2, "upper"),
            t("}{"),
            i(3, "content"),
            t("}")
        }
    ),

    s(
        {
            trig="underset",
            descr="place text in first {} under text in second {}",
        },
        {
            t("\\underset{"),
            i(1, ""),
            t("}{"),
            i(2, ""),
            t("}")
        }
    ),

    s(
        {
            trig="log",
            descr="logarithm of any base",
        },
        {
            t("\\log_{"),
            i(1, "base"),
            t("}\\left({"),
            i(2, "argument"),
            t("}\\right)")
        }
    ),
}

for key, symbol in pairs({
    real = "R",
    natural = "N",
    complex = "C",
    integer = "Z",
    rational = "Q"
}) do
    table.insert(snippets, s("is" .. key, t("\\in\\mathbb{" .. symbol .. "}")))
end

for _, snip in ipairs(snippets) do
    snip.show_condition = is_in_math
    snip.condition = is_in_math
end

return snippets
