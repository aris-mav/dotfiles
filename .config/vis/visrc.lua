-- load standard vis module, providing parts of the Lua API
---@diagnostic disable: undefined-global
require('vis')

vis.events.subscribe(vis.events.INIT, function()
    -- Your global configuration options
    vis:command('set theme gruvbox')
    vis:command('map normal ! :!')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
    -- Your per window configuration options e.g.
    vis:command('set tabwidth 4')
    vis:command('set expandtab')
    vis:command('set showeof off')
    vis:command('set relativenumbers')
    vis:command('set autoindent on')
    vis:command('set ignorecase')
end)
