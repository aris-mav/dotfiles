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
    "tmux",
    "toml",
    "gitcommit",
}

local termux_prefix = os.getenv("PREFIX")
local is_termux = termux_prefix and termux_prefix:match("com.termux")
if not is_termux then
    table.insert(install_languages, "latex")
end

local disabled_languages = {
    "csv",
    "tsv",
    "tex",
    "latex",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = install_languages,
            sync_install = false,
            auto_install = true,
            ignore_install = {},
            highlight = {
                enable = true,
                disable = disabled_languages,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        }
    end
}
