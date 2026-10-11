if vim.env.KITTYSCROLL then
    vim.opt.eventignore = 'FileType'
    vim.opt.clipboard = 'unnamedplus'

    vim.api.nvim_create_autocmd('StdinReadPost', {
        once = true,
        callback = function()
            local chan = vim.api.nvim_open_term(0, {})
            vim.api.nvim_chan_send(
                chan, '\27[1;93m-- SCROLLBACK --\27[0m'
            )
            vim.bo.modifiable = false
            vim.bo.readonly = true
            vim.bo.list = false
        end,
    })

    vim.api.nvim_create_autocmd({ 'VimEnter', 'UIEnter' }, {
        once = true,
        callback = function()
            vim.o.laststatus = 0
            vim.o.cmdheight = 0
            vim.opt.signcolumn = "no"
            vim.o.number = false
            vim.o.relativenumber = false

            vim.keymap.set({ 'n', 'v' }, 'q', 'ZQ')

            for _, key in ipairs({ 'i', 'a', 'o', 'O', 'gI' }) do
                vim.keymap.set('n', key, '<Nop>')
            end
            for _, key in ipairs({ 'A', 'I', 'R', 'cc', 'C', 's', 'S' }) do
                vim.keymap.set({ 'n', 'x' }, key, '<Nop>')
            end
        end,
    })

    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            if vim.v.event.operator == 'y' then
                vim.schedule(function() vim.cmd('quit') end)
            end
        end,
    })
end
