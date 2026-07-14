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
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        event = "BufReadPost",
        cond = function()
            return vim.version().minor > 11
        end,
        config = function()
            require("tree-sitter-manager").setup({
                -- Default Options
                parser_dir = vim.fn.stdpath("data") .. "/site/parser",
                query_dir = vim.fn.stdpath("data") .. "/site/queries",
                assume_installed = {},                -- blacklist languages
                ensure_installed = install_languages, -- parsers to install at startup
                border = "rounded",                   -- border style for the TUI window
                auto_install = true,                  -- auto-install when a new filetype is encountered
                noauto_install = {},                  -- blacklist from auto_install
                highlight = true,                     -- enable treesitter highlighting (use list to whitelist)
                nohighlight = disabled_languages,     -- blacklist from highlight
                languages = {},                       -- override or add new parser sources
                nerdfont = true,                      -- use Nerd Font icons in the manager UI
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        cond = function()
            return vim.version().minor < 12
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
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "+",
                        node_incremental = ".",
                        node_decremental = ",",
                    },
                },
                
            }
        end
    },

}
