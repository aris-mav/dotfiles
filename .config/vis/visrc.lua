require('vis')

vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme gruv_mono')
    require('keybinds')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command('set showeof off')
    vis:command('set autoindent on')
    vis:command('set relativenumbers')
    vis:command('set ignorecase')
    vis:command('set tabwidth 4')
    vis:command('set expandtab')
    vis:command('set shell fish')

    opts = require('ftopts')[win.syntax]
    if opts then
        for _, o in ipairs(opts) do
            vis:command('set ' .. o)
        end
    end
end)

require('fmt')
