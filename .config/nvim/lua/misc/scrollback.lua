if vim.env.KITTYSCROLL then
    vim.opt.eventignore = 'FileType'
    vim.opt.clipboard = 'unnamedplus'
    vim.keymap.set({ 'n', 'v' }, 'q', 'ZQ')
    vim.keymap.set({ 'n', 'v' }, 'd', '<C-d>zz')
    vim.keymap.set({ 'n', 'v' }, 'u', '<C-u>zz')

    for _, key in ipairs({ 'i', 'a', 'o', 'O', 'gI' }) do
        vim.keymap.set('n', key, '<Nop>')
    end
    for _, key in ipairs({ 'A', 'I', 'R', 'cc', 'C', 's', 'S' }) do
        vim.keymap.set({ 'n', 'x' }, key, '<Nop>')
    end
end

vim.api.nvim_create_autocmd('TermOpen', {
    desc = "Enable linenumbers for terminal scrollback.",
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.signcolumn = "no"
        if vim.env.KITTYSCROLL then
            vim.opt.number = true
            vim.opt.relativenumber = true
        end
    end,
})
