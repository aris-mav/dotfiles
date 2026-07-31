local livepreview_available, _ = pcall(require, "livepreview.config")
local previewing = false

local function start_preview()
    vim.cmd("LivePreview start")

    if vim.env.NIRI_SOCKET then
        if vim.env.TMUX then
            vim.fn.jobstart(
                { "tmux",
                    "if-shell", "-F", "#{window_zoomed_flag}", "", "resize-pane -Z"
                },
                { detach = true, }
            )
        end
        vim.fn.jobstart({ "sh", "-c",
            "niri msg action set-column-width 50%; \
            sleep 0.5; \
            niri msg action swap-window-right \
            niri msg action focus-column-left \
            niri msg action focus-column-right"
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
    if vim.env.NIRI_SOCKET then
        if vim.env.TMUX then
            vim.fn.jobstart(
                { "tmux", "resize-pane", "-Z" },
                { detach = true, }
            )
        end
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
        vim.cmd("!FORCE_XO=true $NOTES_DIR/.scripts/nt.sh -p %:p")
    end
end, { desc = 'Preview markdown file', silent = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if previewing then
            stop_preview()
        end
    end
})


-- Buffer-local augroup so re-sourcing this ftplugin (e.g. on `:e` or a
-- filetype re-detect) replaces the autocmd instead of stacking a
-- duplicate copy of it.
local group = vim.api.nvim_create_augroup(
    "MarkdownGqFormat_" .. vim.api.nvim_get_current_buf(),
    { clear = true }
)

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = 0,
    desc = "gq-format markdown paragraphs, skipping $$ math blocks",
    callback = function(event)
        local view = vim.fn.winsaveview()
        local lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)

        local i, n = 1, #lines

        while i <= n do
            if lines[i] == "" then
                -- blank line, nothing to do
                i = i + 1
            elseif lines[i]:match("^%$%$%s*$") then
                -- opening $$ of a math block: skip forward past its
                -- closing $$ without touching anything in between
                i = i + 1
                while i <= n and not lines[i]:match("^%$%$%s*$") do
                    i = i + 1
                end
                i = i + 1 -- past the closing $$
            else
                -- start of a regular paragraph: format it with gq,
                -- relying on gqip to stop at the surrounding blank lines
                vim.api.nvim_win_set_cursor(0, { i, 0 })
                vim.cmd("normal! gqip")

                -- gq can change the line count, so refresh our view of
                -- the buffer before continuing the scan
                lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)
                n = #lines

                -- advance past the (possibly reflowed) paragraph to its
                -- trailing blank line
                while i <= n and lines[i] ~= "" do
                    i = i + 1
                end
            end
        end
        vim.fn.winrestview(view)
    end,
})
