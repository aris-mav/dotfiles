vim.cmd('source ~/.config/vim/keymaps.vim')

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
