return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",

	config = function()
		local ls = require("luasnip")
		local cmp = require("cmp")

		cmp.setup({
			-- ... Your other configuration ...
			mapping = {
				['<CR>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if ls.expandable() then
							ls.expand()
						else
							cmp.confirm({
								select = true,
							})
						end
					else
						fallback()
					end
				end),

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif ls.locally_jumpable(1) then
						ls.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif ls.locally_jumpable(-1) then
						ls.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- ... Your other mappings ...
			},
			-- ... Your other configuration ...
		})
	end,
}
