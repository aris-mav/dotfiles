-- Quickfix bindings
vim.keymap.set("n", "q", "<CR>:lclose | cclose<CR>", { buffer = true, silent = true })
vim.keymap.set("n", "o", "<CR>:lclose | cclose<CR>", { buffer = true, silent = true })
vim.keymap.set("n", "<CR>", "<CR>:lclose | cclose<CR>", { buffer = true, silent = true })
