-- linenumbers
vim.wo.relativenumber = true
vim.wo.number = true

-- Set colors
vim.o.background = "dark"
vim.opt.termguicolors = true

-- Enable cursorline and highlight only the line number, not the entire line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "Orange" })

-- Remove border between vertical windows
-- vim.cmd[[:hi VertSplit ctermfg=bg ctermbg=bg guifg=bg guibg=bg]]
vim.cmd[[set fillchars+=vert:\ ]]

-- remove ~'s from the end of file
vim.opt.fillchars = { eob = ' ' }

-- Indentations
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv", "txt" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
  end,
})

-- set greek keymap and disable it 
-- (then toggle with C-6 on insert mode)
vim.bo.keymap = 'greek'
vim.bo.iminsert = 0

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat = "%f:%l:%c:%m"
else
  vim.opt.grepprg = "grep -nH $*"
  vim.opt.grepformat = "%f:%l:%m"
end

vim.keymap.set('ca', 'g', function()
    -- Check if 'g' is the very first thing typed in the command line
    if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'g' then
        return 'silent grep'
    end
    return 'g'
end, { expr = true })

vim.opt.hlsearch = false -- Do not highlight search results
vim.opt.incsearch = true -- Highlight search results only as you type

vim.opt.scrolloff = 1 -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 2 -- Number of columns to keep to the left and right of the cursor

vim.g.netrw_banner = 0

-- vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_augroup("SpellCheckForSpecificFiletypes", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "SpellCheckForSpecificFiletypes",
    pattern = {
        "markdown",
        "tex",
        "txt",
        "typst",
    },
    callback = function()
        vim.opt_local.spelllang = { "en_gb", "el" }
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 50
    end,
})


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
