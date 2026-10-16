if vim.env.KITTYSCROLL then
    vim.opt.eventignore = 'FileType'
    vim.opt.clipboard = 'unnamedplus'

    vim.api.nvim_create_autocmd('StdinReadPost', {
        once = true,
        callback = function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local chan = vim.api.nvim_open_term(0, {})
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
            vim.api.nvim_chan_send(chan, table.concat(lines, '\r\n'))

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

            for _, key in ipairs({ 'i', 'q' }) do
                vim.keymap.set('n', key, 'ZQ')
            end
            for _, key in ipairs({ 'a', 'o', 'O', 'gI' }) do
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
