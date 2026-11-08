vis.events.subscribe(vis.events.FILE_SAVE_PRE, function(file, path)

    if not path or not path:match("%.md$") then
        return true
    else
        local win = vis.win
        local pos = win and win.selection.pos or 0

        local cmd = "pandoc -f markdown -t markdown --columns=50 --tab-stop=2"
        local status, out, err =
            vis:pipe(file, { start = 0, finish = file.size }, cmd)

        if status ~= 0 or not out or out == "" then
            vis:info("pandoc failed, file written unformatted: " .. (err or ""))
            return true
        end

        file:delete(0, file.size)
        file:insert(0, out)

        if win then
            win.selection.pos = math.min(pos, file.size)
        end
        return true
    end
end)
