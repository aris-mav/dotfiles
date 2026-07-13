if vim.fn.has('nvim-0.12') == 1 then
    require('vim._core.ui2').enable()
end

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
vim.cmd [[set fillchars+=vert:\ ]]

-- remove ~'s from the end of file
vim.opt.fillchars = { eob = ' ' }

-- A TAB character looks like 4 spaces
vim.o.tabstop = 4
-- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.expandtab = true
-- Number of spaces inserted instead of a TAB character
vim.o.softtabstop = 4
-- Number of spaces inserted when indenting
vim.o.shiftwidth = 4
-- Change the above for some cases
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "csv", "tsv", "txt" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
    end,
})

-- match statusline and colorcolumn colours
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    callback = function()
        local colorcolumn_hl = vim.api.nvim_get_hl(0,
            { name = "ColorColumn", link = false })
        local cc_bg = colorcolumn_hl.bg or colorcolumn_hl.ctermbg
        vim.api.nvim_set_hl(0, "StatusLine", { bg = cc_bg })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = cc_bg })
    end,
})

-- colorcolumn, only for suitable files
local column_group = vim.api.nvim_create_augroup("ColumnLine", { clear = true })
vim.api.nvim_create_autocmd({
        "FileType", "VimResized", "WinEnter", "BufWinEnter" },
    {
        group = column_group,
        pattern = "*",
        callback = function()
            if not vim.bo.modifiable
                or vim.bo.readonly
                or vim.bo.buftype ~= ""
            then
                vim.opt_local.colorcolumn = ""
                return
            end

            local ftype = vim.bo.filetype
            if not vim.tbl_contains({
                    'csv',
                    'tsv',
                }, ftype) then
                if vim.tbl_contains({
                        'markdown',
                    }, ftype) then
                    vim.opt_local.colorcolumn = "51"
                    vim.opt_local.textwidth = 50
                else
                    vim.opt_local.colorcolumn = "81"
                    vim.opt_local.textwidth = 80
                end
            end
        end
    }
)

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

vim.opt.hlsearch = false  -- Do not highlight search results
vim.opt.incsearch = true  -- Highlight search results only as you type

vim.opt.scrolloff = 1     -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 2 -- Number of columns to keep to the left and right of the cursor

vim.g.netrw_banner = 0

-- set greek keymap and disable it
-- (then toggle with C-6 on insert mode)
vim.bo.keymap = 'greek'
vim.bo.iminsert = 0

local spellcheck_ft = {
    "markdown",
    "tex",
    "txt",
    "typst",
}

vim.opt.spellfile = vim.fn.stdpath("data") .. "/site/spell/en.utf-8.add"

vim.api.nvim_create_augroup("SpellCheckForSpecificFiletypes", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "SpellCheckForSpecificFiletypes",
    pattern = spellcheck_ft,
    callback = function()
        vim.opt_local.spelllang = { "en_gb", "el" }
        vim.opt_local.spell = true
    end,
})

vim.lsp.config("harper_ls", {
    filetypes = spellcheck_ft,
    settings = {
        ["harper-ls"] = {
            userDictPath = vim.fn.stdpath("data") .. "/site/spell/en.utf-8.add",
            linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,
                UnclosedQuotes = true,
                WrongApostrophe = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                CorrectNumberSuffix = true,
                AvoidBannedWords = false,
            },
            codeActions = {
                ForceStable = false
            },
            markdown = {
                IgnoreLinkTitle = false
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "British",
            maxFileLength = 10000,
            excludePatterns = {}
        }
    }
})

vim.keymap.set("n", "zg", function()
    local harper_clients = vim.lsp.get_clients({ bufnr = 0, name = "harper_ls" })
    local found_action = false
    if #harper_clients > 0 then
        vim.lsp.buf.code_action({
            apply = true,
            filter = function(action)
                if action.title:match("[Uu]ser dictionary") ~= nil then
                    found_action = true
                    return true
                end
                return false
            end,
        })
    end
    if not found_action then
        vim.cmd("normal! zg")
    end
end, { desc = "Add word to dictionary" })

vim.diagnostic.config({
    signs = false,
    underline = true,
    virtual_text = {
        current_line = true,
        prefix = function(diagnostic)
            local icons = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.INFO]  = " ",
                [vim.diagnostic.severity.HINT]  = " ",
            }
            return icons[diagnostic.severity] or "●"
        end,
    },
    severity_sort = true,
    update_in_insert = false,
    float = {
        border = "rounded",
        focusable = false,
    },
})

vim.opt.wrap = false
vim.opt.undofile = true

-- Ignore case in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No line numbers for terminal windows
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.signcolumn = "no"
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})
