--- @module 'blink.cmp'
--- @class blink.cmp.Source
--- @field notes_dir string
--- @field items table<string, table[]>
--- @field jobs table<string, vim.SystemObj?>
local source = {}

local CompletionItemKind = require('blink.cmp.types').CompletionItemKind

-- Each entry describes one nt-backed completion type:
--   name    - unique key, used for caching/job-tracking and as the CompletionItemKind name
--   flag    - the nt.sh flag to invoke for this completion type
--   matches - given (line, col), returns true if completion should trigger here
-- To add a new completion type, just add a new entry below - nothing else
-- in this file needs to change.
local KINDS = {
    {
        name = 'NtTag',
        flag = '-T',
        matches = function(line, col)
            local before_cursor = line:sub(1, col)
            return before_cursor:match('#[A-Za-z_]*$') ~= nil
        end,
    },
    {
        name = 'NtSource',
        flag = '-S',
        matches = function(line, _col)
            return line:match('^Source: ') ~= nil
                or line:match('^%[%^[^%]]*%]: ') ~= nil
        end,
    },
}

-- Register a CompletionItemKind for each entry and remember its numeric
-- index (blink identifies kinds by number, but icons are configured by name
-- via `appearance.kind_icons` in the user's blink config).
for _, k in ipairs(KINDS) do
    local idx = #CompletionItemKind + 1
    CompletionItemKind[idx] = k.name
    k.kind_idx = idx
end

-- Find which KINDS entry (if any) applies at the given position.
local function find_kind(line, col)
    for _, k in ipairs(KINDS) do
        if k.matches(line, col) then
            return k
        end
    end
    return nil
end

function source.new()
    vim.validate('nt_cmp.opts.notes_dir', vim.env.NOTES_DIR, { 'string' })

    local self = setmetatable({}, { __index = source })
    self.notes_dir = vim.env.NOTES_DIR

    -- cache/job state keyed by kind name, e.g. self.items['NtTag']
    self.items = {}
    self.jobs = {}

    return self
end

function source:enabled()
    if vim.bo.filetype ~= 'markdown' then
        return false
    end

    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    return find_kind(line, col) ~= nil
end

function source:get_trigger_characters()
    return { ' ', '#' }
end

function source:get_completions(ctx, callback)
    local line = ctx.line or vim.api.nvim_get_current_line()
    local col = ctx.cursor and ctx.cursor[2] or #line

    local kind = find_kind(line, col)
    if not kind then
        callback({
            items = {},
            is_incomplete_backward = false,
            is_incomplete_forward = false
        })
        return function() end
    end

    local function respond(items)
        callback({
            items = items,
            is_incomplete_backward = false,
            is_incomplete_forward = false,
        })
    end

    -- serve from cache if we've already fetched this kind
    if self.items[kind.name] then
        respond(self.items[kind.name])
        return function() end
    end

    local cmd = { vim.env.NOTES_DIR .. '/.scripts/nt.sh', kind.flag }

    local job = vim.system(cmd, { text = true }, function(result)
        self.jobs[kind.name] = nil

        if result.code ~= 0 then
            vim.schedule(function()
                vim.notify('nt_cmp: pipeline failed: '
                    .. (result.stderr or ''), vim.log.levels.WARN)
            end)
            respond({})
            return
        end

        local items = {}
        for l in (result.stdout or ''):gmatch('[^\n]+') do
            table.insert(items, {
                label = l,
                kind = kind.kind_idx,
                insertText = l,
                insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
            })
        end

        self.items[kind.name] = items
        respond(items)
    end)

    self.jobs[kind.name] = job

    return function()
        local j = self.jobs[kind.name]
        if j then
            j:kill(9)
            self.jobs[kind.name] = nil
        end
    end
end

return source
