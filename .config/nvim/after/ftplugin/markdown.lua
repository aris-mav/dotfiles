local livepreview_available, _ = pcall(require, "livepreview.config")

vim.keymap.set('n', 'gb', function()
    vim.cmd("w")
    if livepreview_available then
        vim.cmd("LivePreview start")
    else
        vim.cmd("!FORCE_XO=true $NOTES_DIR/nt.sh -p %:p")
    end
end, { desc = 'Preview markdown file',silent=true })
