return {
    'mawkler/demicolon.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    keys = { ';', ',' }, -- lazyload demicolon when these are pressed
    config = function()
        require('demicolon').setup()
    end
}
