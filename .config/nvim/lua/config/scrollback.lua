if vim.env.KITTYSCROLL then
    vim.opt.eventignore = 'FileType'
    vim.opt.clipboard = 'unnamedplus'

    vim.api.nvim_create_autocmd('StdinReadPost', {
        once = true,
        callback = function()
            vim.o.number = false
            vim.o.relativenumber = false
            vim.o.signcolumn = 'no'
            vim.o.foldcolumn = '0'
            vim.o.laststatus = 0
            vim.o.cmdheight = 0
            vim.opt.shortmess:append('I')

            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local chan = vim.api.nvim_open_term(0, {})
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
            vim.api.nvim_chan_send(chan, table.concat(lines, '\r\n'))

            vim.bo.modifiable = false
            vim.bo.readonly = true
        end,
    })

    vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
            for _, key in ipairs({ 'i', 'q' }) do
                vim.keymap.set('n', key, 'ZQ')
            end
            for _, key in ipairs({ 'a', 'o', 'O', 'gI' }) do
                vim.keymap.set('n', key, '<Nop>')
            end
            for _, key in ipairs({ 'A', 'I', 'R', 'cc', 'C', 's', 'S' }) do
                vim.keymap.set({ 'n', 'x' }, key, '<Nop>')
            end
            pcall(vim.api.nvim_del_augroup_by_name, 'CmdModeNumbers')
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
