vim.o.laststatus = 3

if vim.fn.has('nvim-0.12') == 1 then
    require('vim._core.ui2').enable()
end

-- Enable cursorline and highlight only the line number, not the entire line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "Orange" })

-- Cursor shapes
vim.opt.guicursor = "n-v:block,i-ci-ve:ver25,r-cr-o:hor20,c:ver25"

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
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ColumnLine", { clear = true }),
    callback = function(args)
        local widths = {
            markdown = 50,
            python = 88,
            csv = 0,
            tsv = 0,
        }
        local bo = vim.bo[args.buf]
        local width = widths[bo.filetype] or 80
        if width == 0 or bo.buftype ~= "" then
            vim.opt_local.colorcolumn = ""
            return
        end
        vim.opt_local.colorcolumn = tostring(width + 1)
        vim.opt_local.textwidth = width
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("TermStartInsert", { clear = true }),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.cmd("startinsert")
    end,
})
vim.api.nvim_create_autocmd("TermClose", {
    callback = function(args)
        if vim.v.event.status == 0 then
            vim.api.nvim_buf_delete(args.buf, { force = true })
        end
    end,
})

local spellcheck_ft = {
    "markdown",
    "tex",
    "txt",
    "typst",
}

vim.lsp.config("harper_ls", {
    filetypes = spellcheck_ft,
    settings = {
        ["harper-ls"] = {
            userDictPath = vim.fn.stdpath("data") .. "/site/spell/en.utf-8.add",
            -- more options here : https://writewithharper.com/docs/rules?utm_source
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
                AvoidCurses = false,
                UseTitleCase = false,
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

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format buffer with LSP on save, if supported",
    callback = function(event)
        local clients = vim.lsp.get_clients({
            bufnr = event.buf,
            method = "textDocument/formatting",
        })
        if #clients == 0 then
            return
        end
        vim.lsp.buf.format({
            bufnr = event.buf,
            timeout_ms = 1000,
        })
    end,
})
