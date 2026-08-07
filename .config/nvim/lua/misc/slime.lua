-- Pre-declare local function references so LSP doesn't complain about globals
local send_to_target
local check_target

if vim.env.TMUX then
    -- declare buffer name for tmux
    vim.g.bname = "slime"

    check_target = function()
        if not vim.g.slime_target or vim.g.slime_target == "" then
            -- tmux syntax is "window.pane" (e.g. 1.3)
            -- the default option below is "!", and it means "last active pane"
            local input_pane = vim.fn.input("Target tmux pane: ", "!")

            if input_pane == "" then
                print("\nCancelled: No tmux pane specified.")
                return false
            end
            vim.g.slime_target = input_pane
        end
        return true
    end

    send_to_target = function(text)
        vim.fn.system({ "tmux", "set-buffer", "-b", vim.g.bname, "--", text })
        vim.fn.system({ "tmux", "paste-buffer", "-p",
            "-b", vim.g.bname, "-t", vim.g.slime_target })
        vim.fn.system({ "tmux", "send-keys", "-t", vim.g.slime_target, "\r" })
    end
elseif vim.env.KITTY_WINDOW_ID or (vim.env.TERM and vim.env.TERM:match("kitty")) then
    check_target = function()
        if not vim.g.slime_target or vim.g.slime_target == "" then
            -- Kitty window ID or @target syntax
            local input_target = vim.fn.input("Kitty target: --match ", "id:2")

            if input_target == "" then
                print("\nCancelled: No Kitty target specified.")
                return false
            end
            vim.g.slime_target = input_target
        end
        return true
    end

    send_to_target = function(text)
        print("sending to " .. vim.g.slime_target)
        vim.fn.system({ "kitten", "@", "send-text", "--bracketed-paste=enable",
            "--match", vim.g.slime_target, text })
        vim.fn.system({
            "kitten", "@", "send-key", "--match", vim.g.slime_target, "\r" })
    end
else
    check_target = function()
        print("Unsupported terminal environment.")
        return false
    end
    send_to_target = function(_)
        print("Cannot send text: terminal not supported.")
    end
end

_G.slime_operator = function(motion_type)
    -- Determine the correct marks based on whether we came from Visual mode
    -- Visual mode uses '< and '>, Normal mode motions use '[ and ']
    local is_visual  = (motion_type == nil)
    local start_mark = is_visual and "'<" or "'["
    local end_mark   = is_visual and "'>" or "']"

    -- Map the motion/visual type to what getregion expects
    local reg_type   = "v"

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
    check_target()
    send_to_target(table.concat(lines, "\n"))
end

vim.keymap.set("n", "<CR><CR>", '<cmd>echo ""<cr>')

vim.keymap.set({ "n", "x" }, "<CR>",
    function()
        vim.o.operatorfunc = "v:lua.slime_operator"
        return "g@"
    end,
    { expr = true, desc = "Send motion or visual selection to tmux pane." }
)

vim.keymap.set("n", "<leader><CR>",
    function()
        if not vim.g.slimestring or vim.g.slimestring == "" then
            vim.g.slimestring = vim.fn.input("Set slimestring : ")
        end
        check_target()
        if vim.g.slimestring ~= "" then
            send_to_target(vim.g.slimestring)
        end
    end,
    { desc = "Send a string to tmux pane." }
)

vim.keymap.set("n", "<CR>c",
    function()
        check_target()
        vim.fn.system({ "tmux", "send-keys", "-t", vim.g.slime_target, 'C-c' })
    end,
    { desc = "Send interrupt singal to pane" }
)
