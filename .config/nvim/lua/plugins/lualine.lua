return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = true,
    event = "VeryLazy",

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

                lualine_a = { 'diff' },
                lualine_b = { 'branch' },
                lualine_c = {
                    {
                        'filename',
                        file_status = true,     -- Displays file status (readonly status, modified status)
                        newfile_status = false, -- Display new file status (new file means no write after created)
                        path = 1,
                        -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                        -- 4: Filename and parent dir, with tilde as the home directory

                        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                        -- for other components. (terrible name, any suggestions?)
                        -- It can also be a function that returns
                        -- the value of `shorting_target` dynamically.
                        symbols = {
                            modified = '[+]',      -- Text to show when the file is modified.
                            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                            unnamed = '[No Name]', -- Text to show for unnamed buffers.
                            newfile = '[New]',     -- Text to show for newly created file before first write
                        }
                    }
                },

                lualine_x = {
                    'encoding',
                    { 'filetype', colored = true, icon_only = true },
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
                    'diagnostics',
                },
                lualine_z = {
                    'location',
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
    end
}
