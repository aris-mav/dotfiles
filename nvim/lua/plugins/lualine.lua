return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = true,
    event = "VeryLazy",
    cond = vim.env.KITTYSCROLL == nil,

    config = function()
        require('lualine').setup {
            options = {
                -- theme = 'gruvbox',
                theme = {
                    normal = {
                        a = { fg = nil, bg = nil },
                        b = { fg = nil, bg = nil },
                        c = { fg = nil, bg = nil },
                    },
                },
                icons_enabled = true,
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }
            },
            sections = {

                lualine_a = {
                    {
                        'diff',
                        padding = { left = 0, right = 1 },
                        source = function()
                            local gs = vim.b.gitsigns_status_dict
                            if gs then
                                return {
                                    added = gs.added,
                                    modified = gs.changed,
                                    removed = gs.removed,
                                }
                            end
                        end,
                    },
                },
                lualine_b = {
                    {
                        'branch',
                        padding = { left = 0, right = 1 },
                    },
                },
                lualine_c = {
                    {
                        'filetype',
                        colored = true,
                        icon_only = true,
                        padding = { left = 1, right = 1 },
                    },
                    {
                        'filename',
                        path = 1,
                        -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                        -- 4: Filename and parent dir, with tilde as the home directory
                        shorting_target = 50, -- Shortens path to leave 40 spaces in the window
                        file_status = true,
                        newfile_status = false,
                        symbols = {
                            modified = '[+]',
                            readonly = '[-]',
                            unnamed = '[No Name]',
                            newfile = '[New]',
                        },
                        padding = { left = 0, right = 0 },
                    },
                },

                lualine_x = {
                    {
                        'diagnostics',
                        padding = { left = 1, right = 0 },
                    }
                },
                lualine_y = {
                    {
                        'lsp_status',
                        -- icon = '',
                        icon = false,
                        symbols = {
                            -- Standard unicode symbols to cycle through for LSP progress:
                            spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                            -- Standard unicode symbol for when LSP is done:
                            done = ' ',
                            -- Delimiter inserted between LSP names:
                            separator = ',',
                        },
                        -- List of LSP names to ignore (e.g., `null-ls`):
                        ignore_lsp = {},
                        -- Display the LSP name
                        show_name = true,
                    },
                },
                lualine_z = {
                    {
                        'encoding',
                        padding = { left = 1, right = 1 },
                    },
                    {
                        'location',
                        padding = { left = 0, right = 0 },
                    }
                }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
        vim.o.laststatus = 3
    end
}
