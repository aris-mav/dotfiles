-- Quickfix bindings
vim.keymap.set("n", "q", ":lclose | cclose<CR>", { buffer = true, silent = true })
vim.keymap.set("n", "o", ":lclose | cclose<CR>", { buffer = true, silent = true })
vim.keymap.set("n", "<CR>", "<CR>:lclose | cclose<CR>", { buffer = true, silent = true })

vim.keymap.set('n', 'dd', function()
    local qf_list = vim.fn.getqflist()
    local current_line_number = vim.fn.line('.')

    if qf_list[current_line_number] then
        table.remove(qf_list, current_line_number)

        -- 'r' replaces the current list with the modified one
        vim.fn.setqflist(qf_list, 'r')

        -- Ensure the cursor doesn't get stuck past the end of the list
        local new_line_number = math.min(current_line_number, #qf_list)
        if new_line_number > 0 then
            vim.fn.cursor(new_line_number, 1)
        end
    end
end, {
    buffer = true,     -- Crucial: only maps 'dd' in the quickfix window
    noremap = true,
    silent = true,
    desc = 'Remove quickfix item under cursor',
})
