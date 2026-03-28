return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-symbols.nvim',
    },

    config = function()

        local builtin = require('telescope.builtin')
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        local copy_filename = function(register)
            return function(prompt_bufnr)

                local selection = action_state.get_selected_entry()
                local path = selection.filename or selection.value

                if path then
                    vim.fn.setreg(register, path)
                    print("Copied '" .. path .. "' into register " .. register .. ".")
                end

                actions.close(prompt_bufnr)
            end
        end

        require('telescope').setup {
            defaults = {
                mappings = {

                    n = {
                        ['dd'] = actions.delete_buffer,
                        ['q'] = actions.close,
                        ["cd"] = function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                            actions.close(prompt_bufnr)
                            -- Depending on what you want put `cd`, `lcd`, `tcd`
                            vim.cmd(string.format("silent lcd %s", dir))
                        end,
                         
                        -- Swap <C-c> and <C-q>
                        ["<C-c>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<C-q>"] = actions.close,

                        ['yy'] = copy_filename('"'),
                        ['<leader>yy'] = copy_filename('+'),
                    },

                    i = {
                        ["<C-c>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<C-q>"] = actions.close,
                        ["<C-y>"] = copy_filename('"'),
                    },

                },
                layout_strategy = "flex",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        preview_cutoff = 60,
                    },
                    vertical = {
                        prompt_position = "top",
                        mirror = true,
                        preview_cutoff = 1,
                    },
                },
                sorting_strategy = "ascending",
                filesize_limit = 0.1, -- MB
            },
        }

        vim.keymap.set('n', '<leader>t', builtin.builtin, { desc = 'Telescope Builtins' })
        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live Grep' })
        vim.keymap.set('n', '<leader>m', builtin.marks, { desc = 'Live Grep' })

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
