-- linenumbers
vim.wo.relativenumber = true
vim.wo.number = true

-- Set colors
vim.o.background = "dark"
vim.opt.termguicolors = true
vim.cmd([[colorscheme gruvbox]])

-- Remove border between vertical windows
-- vim.cmd[[:hi VertSplit ctermfg=bg ctermbg=bg guifg=bg guibg=bg]]
vim.cmd[[set fillchars+=vert:\ ]]

-- Indentations
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.hlsearch = false -- Do not highlight search results
vim.opt.incsearch = true -- Highlight search results only as you type

vim.opt.scrolloff = 1 -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 2 -- Number of columns to keep to the left and right of the cursor

vim.g.netrw_banner = 0

-- vim.opt.cursorline = true
-- vim.opt.clipboard = "unnamedplus"

-- Wrap text
vim.opt.textwidth = 80
vim.opt.wrap = true

vim.opt.undofile = true

-- Ignore case in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No line numbers for terminal windows
vim.api.nvim_create_autocmd('TermOpen',{
    group = vim.api.nvim_create_augroup('custom-term-open', {clear = true }),
    callback = function()
        vim.opt.signcolumn = "no"
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

-- Julia lsp config
-- require'lspconfig'.julials.setup{
--     on_new_config = function(new_config, _)
--         local julia = vim.fn.expand("C:\\Users\\arism\\.julia\\environments\\nvim-lspconfig")
--         if require'lspconfig'.util.path.is_file(julia) then
--             new_config.cmd[1] = julia
--         end
--     end
-- }
