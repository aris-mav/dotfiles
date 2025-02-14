return {
    'nvim-telescope/telescope.nvim', --tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,

    require('telescope').setup{
        defaults = {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            mappings = {
                n = {
                    ['dd'] = require('telescope.actions').delete_buffer,
                    ['q'] = require('telescope.actions').close
                }, -- n
            } -- mappings
        }, -- defaults
    }
}
