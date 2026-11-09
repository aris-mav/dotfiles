local n = vis.modes.VISUAL
local v = vis.modes.NORMAL

vis:map(n, ' y', '"+y')
vis:map(v, ' y', '"+y')
vis:map(n, ' p', '"+p')
vis:map(v, ' p', '"+p')

vis:command('map normal <M-h> <C-w>h')
vis:command('map normal <M-j> <C-w>j')
vis:command('map normal <M-k> <C-w>k')
vis:command('map normal <M-l> <C-w>l')

vis:map(n, '<F5>', function()
    vis:command('e!')
end, 'Reload file from disk')
