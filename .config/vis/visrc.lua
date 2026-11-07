-- load standard vis module, providing parts of the Lua API
---@diagnostic disable: undefined-global
---@diagnostic disable: unused-local
require('vis')

local n = vis.modes.VISUAL
local v = vis.modes.NORMAL

vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme gruvbox')

    vis:map(n, ' y', '"+y')
    vis:map(v, ' y', '"+y')
    vis:map(n, ' p', '"+p')
    vis:map(v, ' p', '"+p')

    vis:map(vis.modes.NORMAL, '<F5>', function()
        vis:command('e!')
    end, 'Reload file from disk')

    vis:command('map normal ! :!')

    vis:command('map normal <M-h> <C-w>h')
    vis:command('map normal <M-j> <C-w>j')
    vis:command('map normal <M-k> <C-w>k')
    vis:command('map normal <M-l> <C-w>l')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)

    vis:command('set showeof off')
    vis:command('set autoindent on')
    vis:command('set relativenumbers')
    vis:command('set ignorecase')
    vis:command('set tabwidth 4')
    vis:command('set expandtab')
    vis:command('set shownewlines')

end)

require('ftopts')
