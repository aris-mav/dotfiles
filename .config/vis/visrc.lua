-- load standard vis module, providing parts of the Lua API
---@diagnostic disable: undefined-global
---@diagnostic disable: unused-local
require('vis')

vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme gruvbox')
    vis:command('map normal ! :!')
    vis:map(n, " y", '"+y')
    vis:map(v, " y", '"+y')
    vis:map(n, " p", '"+p')
    vis:map(v, " p", '"+p')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command('set tabwidth 4')
    vis:command('set expandtab')
    vis:command('set showeof off')
    vis:command('set relativenumbers')
    vis:command('set autoindent on')
    vis:command('set ignorecase')
end)
