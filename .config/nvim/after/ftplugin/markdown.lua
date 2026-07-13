local livepreview_available, _ = pcall(require, "livepreview.config")
local previewing = false

local function start_preview()
    if vim.env.TMUX then
        vim.fn.jobstart(
            { "tmux",
                "if-shell", "-F", "#{window_zoomed_flag}", "", "resize-pane -Z"
            },
            { detach = true, }
        )
    end
    vim.cmd("LivePreview start")
    if vim.env.NIRI_SOCKET then
        vim.fn.jobstart({ "sh", "-c",
            "niri msg action set-column-width 50%; \
            sleep 0.5; \
            niri msg action swap-window-right"
        }, { detach = true })
    end
end

local function close_preview_window()
    local win_raw = vim.fn.system({ "niri", "msg", "-j", "windows" })
    local ok_win, wins = pcall(vim.json.decode, win_raw)
    if not ok_win then return end

    for _, w in ipairs(wins) do
        if w.title and w.title:find("Live preview") then
            vim.fn.jobstart({
                "niri", "msg", "action", "close-window", "--id", tostring(w.id)
            }, { detach = true })
        end
    end
end

local function stop_preview()
    if vim.env.TMUX then
        vim.fn.jobstart(
            { "tmux", "resize-pane", "-Z" },
            { detach = true, }
        )
    end
    if vim.env.NIRI_SOCKET then
        vim.fn.jobstart({ "niri", "msg", "action", "maximize-window-to-edges" },
            { detach = true, })
        close_preview_window()
    end
end

vim.keymap.set('n', 'gb', function()
    if livepreview_available then
        if not previewing then
            vim.cmd("w")
            start_preview()
            previewing = true
        else
            stop_preview()
            previewing = false
        end
    else
        vim.cmd("!FORCE_XO=true $NOTES_DIR/nt.sh -p %:p")
    end
end, { desc = 'Preview markdown file', silent = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
       if previewing then
           stop_preview()
       end
    end
})
