-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Slime thing (if plugin is not available)
-- vim.api.nvim_set_keymap('v', '<cr>', 'y<C-w>wpi<cr><C-\\><C-N><C-w>w', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<cr>', 'Y<C-w>wpi<cr><C-\\><C-N><C-w>w', { noremap = true, silent = true })

-- Open side window to the left using leader v and bottom window using leader s
vim.keymap.set("n", "<leader>v", ":vs | Ex | vert resize 67 | set wfw | echo '' <cr>", { remap = true, silent = false })
vim.keymap.set("n", "<leader>s", ":below split | Ex | resize 15 | set wfh | echo '' <cr>", { remap = true, silent = false })

-- Map leader-w to :w
vim.keymap.set("n", "<leader>w", ":w <cr>", { remap = true, silent = false })

-- Map leader-e to netrw for the directory of curent file
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { remap = true, silent = false })

-- Map leader-c to activate spellchecker
vim.keymap.set("n", "<leader>c", ":setlocal spell spelllang=en_us <cr>", { remap = true, silent = false })

-- cd to the folder containing the current file
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>')

-- Keep cursor centered after some big movements
vim.keymap.set("n", "n", "nzzzv", { remap = true, silent = false })
vim.keymap.set("n", "N", "Nzzzv", { remap = true, silent = false })
vim.keymap.set("n", "<C-f>", "<C-f>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "<C-b>", "<C-b>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "<C-d>", "<C-d>zzzv", { remap = true, silent = false })
vim.keymap.set("n", "<C-u>", "<C-u>zzzv", { remap = true, silent = false })

-- U for redo
vim.keymap.set("n", "U", "<C-r>", { remap = true, silent = false })

-- Map leader-y to yank in plus register in normal and visual mode and leader-p to paste from plus register in normal and visual mode
vim.keymap.set({ "n", "v" } , "<leader>y", '\"+y', { remap = true, silent = false })
vim.keymap.set({ "n", "v" } , "<leader>p", '\"+p', { remap = true, silent = false })

-- Quickfix keymaps
function ToggleQuickfix()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end
vim.keymap.set('n', "<A-q>", ':lua ToggleQuickfix()<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<A-n>", ":cn <cr>", { remap = true, silent = false })
vim.keymap.set("n", "<A-p>", ":cp <cr>", { remap = true, silent = false })

-- Reload config
vim.keymap.set('n', '<leader>rl', function()
  dofile(vim.env.MYVIMRC)
end, { desc = 'Reload init.lua' })

-- Swap windows using alt+hjkl
vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true, silent = true })

-- Same as above, but for terminal mode
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h", { noremap = true, silent = true })
vim.keymap.set("t", "<A-j>", "<C-\\><C-N><C-w>j", { noremap = true, silent = true })
vim.keymap.set("t", "<A-k>", "<C-\\><C-N><C-w>k", { noremap = true, silent = true })
vim.keymap.set("t", "<A-l>", "<C-\\><C-N><C-w>l", { noremap = true, silent = true })

