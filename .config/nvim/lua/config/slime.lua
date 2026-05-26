-- set target pane 
vim.g.tpane = "!"
-- Options are: '.bottom-right' or 'window.pane' or '!' (last active pane)
-- change interactively using `:let g:target_pane = ":1.3"`

-- set buffer name
vim.g.bname = "slime"

local function grab_selection()

    -- Exit visual mode cleanly to update the selection markers ('< and '>)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true
    )

    local lines = vim.fn.getregion(
        vim.fn.getpos("'<"),
        vim.fn.getpos("'>"),
        { type = vim.fn.visualmode() }
    )

    local text = table.concat(lines, "\n")

    return text

end

local function send_tmux(text)

    vim.fn.system({"tmux", "set-buffer",
        "-b", vim.g.bname, text,
    })
    vim.fn.system({"tmux", "paste-buffer", "-p",
        "-b", vim.g.bname, "-t", vim.g.tpane,
    })
    vim.fn.system({"tmux", "send-keys",
        "-t", vim.g.tpane, "\r",
    })

end

vim.keymap.set( "v", "<cr>",
    function()
        send_tmux(grab_selection())
    end,
    { desc = "Send selection to tmux" }
)
