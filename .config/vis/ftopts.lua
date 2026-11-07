local ft_set_opts = {
    lua      = { 'colorcolumn 81' },
    julia    = { 'colorcolumn 81' },
    python   = { 'colorcolumn 89', 'showspaces' },
    markdown = { 'tabwidth 2', 'colorcolumn 51' },
    text     = { 'expandtab off', 'colorcolumn 72' },
    makefile = { 'tabwidth 8', 'expandtab off' },
}

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    local opts = ft_set_opts[win.syntax]
    if opts then
        for _, o in ipairs(opts) do
            vis:command('set ' .. o)
        end
    end
end)
