-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Quit with ctrl-q or <leader>q
vim.keymap.set('n', '<C-q>', ":q<CR>")
vim.keymap.set('n', '<leader>q', ":q<CR>")

-- Map leader-w to :w
vim.keymap.set("n", "<leader>w", ":w <cr>", { remap = true, silent = false })

-- Map leader-e to netrw for the directory of curent file
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { remap = true, silent = false })

-- Keep cursor centered after some big movements
vim.keymap.set("n", "n", "nzzzv", { remap = true, silent = false })
vim.keymap.set("n", "N", "Nzzzv", { remap = true, silent = false })
-- vim.keymap.set("n", "<C-f>", "<C-f>zzzv", { remap = true, silent = false })
-- vim.keymap.set("n", "<C-b>", "<C-b>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "<C-d>", "<C-d>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "<C-u>", "<C-u>zzzv", { remap = true, silent = false })

-- Keep selection alive after indenting in Visual Mode
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- U for redo
vim.keymap.set("n", "U", "<C-r>", { remap = true, silent = false })

-- yank and put in plus register
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { remap = true, silent = false })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { remap = true, silent = false })
vim.keymap.set({ "v" }, "<leader>d", '"+d', { remap = true, silent = false })

-- Quickfix keymaps
function ToggleQuickfix()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end

vim.keymap.set('n', "<A-q>", ':lua ToggleQuickfix()<CR>', { noremap = true, silent = true })

-- Swap windows using alt+hjkl
vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h", { noremap = true, silent = true })
vim.keymap.set("t", "<A-j>", "<C-\\><C-N><C-w>j", { noremap = true, silent = true })
vim.keymap.set("t", "<A-k>", "<C-\\><C-N><C-w>k", { noremap = true, silent = true })
vim.keymap.set("t", "<A-l>", "<C-\\><C-N><C-w>l", { noremap = true, silent = true })

-- Readonly options for convenience
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    callback = function()
        -- Check if the buffer is read-only or not modifiable
        if vim.bo.readonly or not vim.bo.modifiable then
            local opts = { buffer = true, silent = true }

            vim.keymap.set("n", "d", "<C-d>zz", opts)
            vim.keymap.set("n", "u", "<C-u>zz", opts)
            vim.keymap.set("n", "q", ":q<CR>", opts)
        end
    end,
})

vim.keymap.set("n", "gx", function()
    local word = vim.fn.expand("<cWORD>")
    -- Remove wrapping parentheses or brackets
    local clean = word:match("^%((.+)%)$") or word:match("^%[(.+)%]$") or word
    -- Match DOI pattern, stopping before ), ], } or whitespace
    local doi = clean:match("(10%.%d+/%S-[^%)%]%}%s]*)")
    if doi then
        -- Remove any dots at the very end of the DOI string
        doi = doi:gsub("%.+$", "")
        -- convert to url
        local url = "https://doi.org/" .. doi
        -- Change 'xdg-open' to 'open' on macOS, or 'start' on Windows
        vim.fn.jobstart({ "xdg-open", url }, { detach = true })
    else
        vim.cmd("normal! gx")
    end
end, { noremap = true, silent = true })

-- copy current filename
vim.keymap.set("n", "cp", function()
    vim.fn.setreg("+", vim.fn.expand("%"))
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        -- 0.12 defaults
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts)
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
        -- custom bindings
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>=', function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})
