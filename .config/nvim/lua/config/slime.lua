-- Direct tmux command targeting the right pane ('.bottom-right', '.1', ...)
-- "!" means last active pane
local target_pane = "!"

local function send_selection_to_tmux()

    -- Exit visual mode cleanly to update the selection markers ('< and '>)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true
    )

    -- Extract the visually selected text range
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Get the exact text region between the visual marks
    local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.visualmode() })
    local text = table.concat(lines, "\n")  .. "\n\r"

    vim.fn.system({ "tmux", "set-buffer", text })
    vim.fn.system({ "tmux", "paste-buffer", "-dp", "-t", target_pane })
end

vim.keymap.set( "v", "<cr>", send_selection_to_tmux,
    { desc = "Send selection to tmux" }
)
