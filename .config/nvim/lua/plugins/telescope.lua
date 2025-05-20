return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- lazy = true,

    config = function()

        local telescopeConfig = require("telescope.config")
        local util = require("telescope.utils")
        local builtin = require('telescope.builtin')
        local is_git_repo = function()
            return util.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })[1] == "true"
        end
        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--hidden")
        -- I don't want to search in the `.git` directory.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*")

        require('telescope').setup {
            defaults = {
                mappings = {
                    n = {
                        ['dd'] = require('telescope.actions').delete_buffer,
                        ['q'] = require('telescope.actions').close,
                        ["cd"] = function(prompt_bufnr)
                            local selection = require("telescope.actions.state").get_selected_entry()
                            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                            require("telescope.actions").close(prompt_bufnr)
                            -- Depending on what you want put `cd`, `lcd`, `tcd`
                            vim.cmd(string.format("silent lcd %s", dir))
                        end,
                    },
                },
                layout_strategy = "flex",
                layout_config = {
                    horizontal = {
                        prompt_position = "bottom",
                        preview_width = 0.5,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.9,
                    height = 0.8,
                    preview_cutoff = 120,
                },
                sorting_strategy = "ascending",
                filesize_limit = 0.1, -- MB
            },
            pickers = {
                find_files = {
                    find_command = (is_git_repo()
                        and { "git", "ls-files", "--cached", "--others", "--exclude-standard" }
                        or { "rg", "--files","--no-ignore", "--hidden", "--glob", "!**/.git/*" }),
                    live_grep = {
                        -- Use `git ls-files` to get tracked files and pass them to `rg`
                        find_command = { "rg", "--files", "--no-ignore", "--hidden", "--glob", "!**/.git/*" },
                        path_display = { "smart" },
                    },
                },
            },
            vim.keymap.set('n', '<leader>t', builtin.builtin, { desc = 'Telescope Builtins' }),
            vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffers' }),
            vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' }),
            vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live Grep' }),
            vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = 'Diagnostics' }),

        }
    end,
}
