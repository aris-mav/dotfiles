if vim.env.KITTY_SCROLLBACK_PAGER then
    vim.opt.eventignore = 'FileType'
    vim.opt.clipboard = 'unnamedplus'
    vim.keymap.set('n', 'q', 'ZQ')
    vim.keymap.set('n', 'd', '<C-d>zz')
    vim.keymap.set('n', 'u', '<C-u>zz')

    for _, key in ipairs(
        { 'i', 'a', 'A', 'I', 'o', 'O', 'R', 'gI', 'cc', 'C', 's', 'S' }
    ) do
        vim.keymap.set('n', key, '<Nop>')
    end
end
