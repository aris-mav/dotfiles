-- man pager options
vim.keymap.set("n", "d", "<C-d>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "u", "<C-u>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "f", "<C-f>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "b", "<C-b>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "q", ":q<CR>", { buffer = true, silent = true })
