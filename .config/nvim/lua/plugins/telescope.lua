return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-symbols.nvim',
    },

    config = function()

        local builtin = require('telescope.builtin')

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
                        preview_width = 0.55,
                        preview_cutoff = 60,
                    },
                    vertical = {
                        prompt_position = "top",
                        mirror = true,
                        preview_cutoff = 1,
                    },
                },
                sorting_strategy = "descending",
                filesize_limit = 0.1, -- MB
            },
        }

        vim.keymap.set('n', '<leader>t', builtin.builtin, { desc = 'Telescope Builtins' })
        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live Grep' })
        vim.keymap.set('n', '<leader>m', builtin.marks, { desc = 'Live Grep' })
        vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = 'Diagnostics' })

        for _, sym in ipairs(
            {
                'latex',
                'julia',
                'kaomoji',
                'emoji',
                'gitmoji',
                'math',
                'nerd',
                '',
            }
        ) do

            vim.keymap.set('n',
                "<leader>s" .. string.sub(sym, 1, 1),
                function()
                    builtin.symbols({ sources = { sym } })
                end,
                { desc = "Symbols: " .. sym }
            )
        end

    end,
}
