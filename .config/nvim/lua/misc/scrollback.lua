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

    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            if vim.v.event.operator == "y" then
                vim.schedule(function()
                    vim.cmd("quit")
                end)
            end
        end,
    })
end
