return {
    "samharju/yeet.nvim",

    -- version = "*", -- use the latest release, remove for master
    cmd = "Yeet",
    opts = {
        -- Send <CR> to channel after command for immediate execution.
        yeet_and_run = true,
        -- Send C-c before execution
        interrupt_before_yeet = false,
        -- Send 'clear<CR>' to channel before command for clean output.
        clear_before_yeet = false,
        -- Enable notify for yeets. Success notifications may be a little
        -- too much if you are using noice.nvim or fidget.nvim
        notify_on_success = false,
        -- Print warning if pane list could not be fetched, e.g. tmux not running.
        warn_tmux_not_running = false,
    },
    keys = {
        -- Yeet visual selection. Useful sending core to a repl or running multiple commands.
        {
            "<cr>",
            function()
                require("yeet").execute_selection(
                {yeet_and_run = true, clear_before_yeet = false, notify_on_success = false }
                )
            end,
            mode = { "v" },
        },

        -- Pop command cache open
        {
            "<leader><cr>",
            function() require("yeet").list_cmd() end,
        },

        -- Open target selection
        {
            "<leader>yt", function() require("yeet").select_target() end,
        },
    }
}
