return {
    'mawkler/demicolon.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
        require('demicolon').setup()
    end
}
