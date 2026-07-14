return {
    'brianhuster/live-preview.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        -- Pass it as a single string instead of a table
        if vim.env.NIRI_SOCKET then
            require('livepreview.config').set({
                browser = "firefox --new-window"
            })
        end
    end,
}
