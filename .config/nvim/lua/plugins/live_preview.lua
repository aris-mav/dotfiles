return {
    'brianhuster/live-preview.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        -- Pass it as a single string instead of a table
        require('livepreview.config').set({
            browser = "firefox --new-window"
        })

        vim.keymap.set('n', '<leader>l', '<cmd>LivePreview start<CR>', {
            desc = 'Start Live Preview in new Firefox window'
        })
    end,
}
