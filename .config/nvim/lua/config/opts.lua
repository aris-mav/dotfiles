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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
  end,
})

-- Use ripgrep
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.hlsearch = false -- Do not highlight search results
vim.opt.incsearch = true -- Highlight search results only as you type

vim.opt.scrolloff = 1 -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 2 -- Number of columns to keep to the left and right of the cursor

vim.g.netrw_banner = 0

-- vim.opt.cursorline = true
-- vim.opt.clipboard = "unnamedplus"

-- Wrap text
-- vim.opt.textwidth = 80
vim.opt.wrap = false

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
