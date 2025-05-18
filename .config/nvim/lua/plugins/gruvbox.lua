return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
    config = function()
        require("gruvbox").setup({
            transparent_mode = false,
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = false,
                emphasis = false,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            -- contrast = "hard", -- can be "hard", "soft" or empty string
            palette_overrides = {},
            dim_inactive = false,
            overrides = {
                SignColumn = { bg = "none" },
                DiagnosticSignError = { fg = "#fb4934", bg = "none" },
                DiagnosticSignWarn  = { fg = "#fabd2f", bg = "none" },
                DiagnosticSignInfo  = { fg = "#83a598", bg = "none" },
                DiagnosticSignHint  = { fg = "#8ec07c", bg = "none" },
            }
        })
        vim.cmd.colorscheme("gruvbox")
    end,
}
