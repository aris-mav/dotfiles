vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

vim.keymap.set('n', 'gb',
    '<cmd>!FORCE_XO=true $NOTES_DIR/.scripts/nt.sh -p %:p<CR>',
    { desc = 'Markdown HTML preview', silent = true }
)

local livepreview_available, _ = pcall(require, "livepreview.config")
local previewing = false

-- look for backlinks to current file
vim.keymap.set("n", "gl", function()
    vim.cmd("silent grep! " .. vim.fn.shellescape(vim.fn.expand("%:t")))
    vim.cmd("copen")
end, { buffer = true })

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
        close_preview_window()
    end
end

vim.keymap.set('n', '<leader>l', function()
    if livepreview_available then
        if not previewing then
            vim.cmd("w")
            start_preview()
            previewing = true
        else
            stop_preview()
            previewing = false
        end
    end
end, { desc = 'Toggle live preview', silent = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if previewing then
            stop_preview()
        end
    end
})

-- Each "skippable" block type is described by:
--   starts(line)         -> true if this line opens the block
--   is_delimited         -> true: skip forward to a matching closer line
--                           false: skip forward while `starts` keeps matching
--                           (i.e. a "run" of similar lines, like a table)
--   ends(line)            -> only used when is_delimited; matches the closer
local block_types = {
    { -- $$ ... $$ math block (allow indentation, e.g. inside a list item)
        starts = function(l) return l:match("^%s*%$%$%s*$") ~= nil end,
        ends = function(l) return l:match("^%s*%$%$%s*$") ~= nil end,
        is_delimited = true,
    },
    { -- ::: ... ::: pandoc fenced div (allow indentation)
        starts       = function(l) return l:match("^%s*:::+") ~= nil end,
        ends         = function(l) return l:match("^%s*:::+%s*$") ~= nil end,
        is_delimited = true,
    },
    { -- ``` ... ``` fenced code block
        starts = function(l) return l:match("^%s*```") ~= nil end,
        ends = function(l) return l:match("^%s*```") ~= nil end,
        is_delimited = true,
    },
    { -- table: a run of contiguous table-like lines, no distinct closer
        starts = function(line)
            return line:match("^%s*|") ~= nil
                or (line:match("^%s*[-:| ]+$") ~= nil
                    and line:match("[-|]") ~= nil)
        end,
        is_delimited = false,
    },
}
