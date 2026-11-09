-- man pager options
vim.keymap.set("n", "f", "<C-f>", { remap = true, silent = false })
vim.keymap.set("n", "b", "<C-b>", { remap = true, silent = false })

vim.keymap.set("n", "o", function()
    require('man').show_toc()
end, { buffer = true, silent = true })
