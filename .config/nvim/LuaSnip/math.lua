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
          and MATH_ENVIRONMENTS[query.get_node_text(names[1], buf):match "[A-Za-z]+"]
        then
          return true
        end
      end
      node = node:parent()
    end
    return false
  end
end



return { -- these are meant to be shared between tex and md files

    s(
        {
            trig="upright",
            dscr="non-italic symbols in equations",
            show_condition=is_in_math
        },
        {
            t("\\mathrm{"),
            i(1, "symbol"),
            t("}"),
        },
        {condition = is_in_math }
    ),

    s(
        {
            trig="frac",
            descr="Latex fraction",
            show_condition=is_in_math
        },
        {
            t("\\frac{"),
            i(1, "numerator"),
            t("}{"),
            i(2, "denominator"),
            t("}"),
        },
        {condition = is_in_math }
    ),

    s(
        {
            trig="derivative",
            descr="Leibnitz notation for 1st monovariate derivative",
            show_condition=is_in_math
        },
        {
            t("\\frac{\\mathrm{d} "),
            i(1, "f"),
            t(" }{\\mathrm{d} "),
            i(2, "x"),
            t(" }"),
        },
        {condition = is_in_math }
    ),

    s(
        {
            trig="integral",
            descr="Bounded integral",
            show_condition=is_in_math
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
        },
        {condition = is_in_math }
    ),

    s(
        {
            trig="underset",
            descr="place text in first {} under text in second {}",
            show_condition=is_in_math
        },
        {
            t("\\underset{"),
            i(1, ""),
            t("}{"),
            i(2, ""),
            t("}")
        },
        {condition = is_in_math }
    ),
}
