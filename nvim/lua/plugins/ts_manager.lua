local install_languages = {
    "lua",
    "python",
    "markdown",
    "markdown_inline",
    "yaml",
    "julia",
    "rust",
    "bash",
    "fish",
    "vim",
    "toml",
    "gitcommit",
    "latex",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        ts.install(install_languages)
    end,
}
