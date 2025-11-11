return {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },
    init = function()
        -- Your VimTeX config here
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_mappings_prefix = "<leader>l"
    end,
}
