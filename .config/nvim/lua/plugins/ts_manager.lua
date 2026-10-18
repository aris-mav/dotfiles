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
}

local termux_prefix = os.getenv("PREFIX")
local is_termux = termux_prefix and termux_prefix:match("com.termux")
if not is_termux then
    table.insert(install_languages, "latex")
end

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
