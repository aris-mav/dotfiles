--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
local kind_idx = #CompletionItemKind + 1
CompletionItemKind[kind_idx] = 'nt_source'

function source.new()
    vim.validate('nt_sources.opts.notes_dir', vim.env.NOTES_DIR, { 'string' })

    local self = setmetatable({}, { __index = source })
    self.notes_dir = vim.env.NOTES_DIR
    self.items = nil -- cache, populated lazily on first request
    self.job = nil
    return self
end

function source:enabled()
    if vim.bo.filetype ~= 'markdown' then
        return false
    end

    local line = vim.api.nvim_get_current_line()

    return line:match('^Source: ') ~= nil
        or line:match('^%[%^[^%]]*%]: ') ~= nil
end

function source:get_trigger_characters()
    return { ' ' }
end

function source:refresh(callback)
    local cmd = { vim.env.NOTES_DIR .. '/nt.sh', '-S' }

    self.job = vim.system(cmd, { text = true }, function(result)
        self.job = nil
        if result.code ~= 0 then
            vim.schedule(function()
                vim.notify('nt_sources: pipeline failed: ' .. (result.stderr or ''), vim.log.levels.WARN)
            end)
            callback({})
            return
        end

        local items = {}
        for line in (result.stdout or ''):gmatch('[^\n]+') do
            table.insert(items, {
                label = line,
                kind = kind_idx,
                insertText = line,
                insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
            })
        end
        self.items = items
        callback(items)
    end)
end

function source:get_completions(ctx, callback)
    local function respond(items)
        callback({
            items = items,
            is_incomplete_backward = false,
            is_incomplete_forward = false,
        })
    end

    if self.items then
        respond(self.items)
    else
        self:refresh(respond)
    end

    return function()
        if self.job then
            self.job:kill(9)
            self.job = nil
        end
    end
end

return source
