return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            char = { enabled = false },
            search = { enabled = true },
        },
        search = {
            mode = "fuzzy",
            multi_window = false, -- prevents messing up autocomplete windows
        },
        label = {
            rainbow = {
                enabled = true,
                shade = 5,
            },
        },
    },

    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function() require("flash").treesitter() end,
            desc = "Flash Treesitter"
        },
        {
            "r",
            mode = "o",
            function() require("flash").remote() end,
            desc = ""
        },
        {
            "R",
            mode = { "o", "x" },
            function() require("flash").treesitter_search() end,
            desc = "Treesitter Search"
        },
        {
            "<c-s>",
            mode = { "c" },
            function() require("flash").toggle() end,
            desc = "Toggle Flash Search"
        },
    },
}
