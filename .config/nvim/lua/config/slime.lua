-- Direct tmux command targeting the right pane ('.bottom-right', '.1', ...)
-- "!" means last active pane
local target_pane = "!"
local buffer_name = "slime"

local function send_selection_to_tmux()

    -- Exit visual mode cleanly to update the selection markers ('< and '>)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true
    )

    -- Extract the visually selected text range
    local lines = vim.fn.getregion(
        vim.fn.getpos("'<"),
        vim.fn.getpos("'>"),
        { type = vim.fn.visualmode() }
    )

    local text = table.concat(lines, "\n")

    vim.fn.system({"tmux", "set-buffer",
        "-b", buffer_name, text,
    })
    vim.fn.system({"tmux", "paste-buffer", "-p",
        "-b", buffer_name, "-t", target_pane,
    })
    vim.fn.system({"tmux", "send-keys",
        "-t", target_pane, "\r",
    })
end

vim.keymap.set( "v", "<cr>", send_selection_to_tmux,
    { desc = "Send selection to tmux" }
)
