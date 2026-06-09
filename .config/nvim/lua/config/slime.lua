-- declare buffer name for tmux
vim.g.bname = "slime"

local function send_to_tpane(text)

    vim.fn.system(
        { "tmux", "set-buffer", "-b", vim.g.bname, "--", text }
    )
    vim.fn.system(
        { "tmux", "paste-buffer", "-p", "-b", vim.g.bname, "-t", vim.g.tpane }
    )
    vim.fn.system(
        { "tmux", "send-keys", "-t", vim.g.tpane, "\r" }
    )

end

local function check_tpane()
    if not vim.g.tpane or vim.g.tpane == "" then
        -- tmux syntax is "window.pane" (e.g. 1.3)
        -- the default option below is "!", and it means "last active pane"
        local input_pane = vim.fn.input("Target tmux pane: ", "!")

        if input_pane == "" then
            print("\nCancelled: No tmux pane specified.")
            return
        end
        vim.g.tpane = input_pane
    end
end

_G.slime_operator = function(motion_type)
    -- Determine the correct marks based on whether we came from Visual mode
    -- Visual mode uses '< and '>, Normal mode motions use '[ and ']
    local is_visual  = (motion_type == nil)
    local start_mark = is_visual and "'<" or "'["
    local end_mark   = is_visual and "'>" or "']"

    -- Map the motion/visual type to what getregion expects
    local reg_type = "v"

    if is_visual then
        reg_type = vim.fn.visualmode()
    elseif motion_type == "line" then
        reg_type = "V"
    elseif motion_type == "block" then
        reg_type = "\22"
    end

    local lines = vim.fn.getregion(
        vim.fn.getpos(start_mark),
        vim.fn.getpos(end_mark),
        { type = reg_type }
    )
    check_tpane()
    send_to_tpane(table.concat(lines, "\n"))
end

vim.keymap.set({ "n", "x" }, "<CR>",
    function()
        vim.o.operatorfunc = "v:lua.slime_operator"
        return "g@"
    end,
    { expr = true, desc = "Send motion or visual selection to tmux pane." }
)

vim.keymap.set("n", "<leader><CR>",
    function()
        check_tpane()
        if not vim.g.slimestring or vim.g.slimestring == "" then
            vim.g.slimestring = vim.fn.input("Set slimestring : ")
        end
        if vim.g.slimestring ~= "" then
            send_to_tpane(vim.g.slimestring)
        end
    end,
    { desc = "Send a string to tmux pane." }
)

vim.keymap.set("n", "<CR>c",
    function()
        check_tpane()
        vim.fn.system({ "tmux", "send-keys", "-t", vim.g.tpane, 'C-c' })
    end,
    { desc = "Send interrupt singal to pane" }
)
