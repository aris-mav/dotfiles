" Map leader to space 
let mapleader = " "
let maplocalleader = "\\"

" General Keymaps 
nnoremap <leader>q :q<CR>
nmap <leader>w :w <cr>
nmap <leader>e :Ex<cr>
nmap <leader>b :buffers<cr>:b<space> 
nmap <leader>m :marks<cr>:mark<space>
nmap <leader>f :find *
nmap <leader>/ :grep<space>

" Keep selection alive after indenting in Visual Mode
vnoremap < <gv
vnoremap > >gv

" Redo 
nnoremap U <C-r>

" Clipboard Copy/Paste 
" Yank to + register
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" Paste from + register
nnoremap <leader>p "+p
vnoremap <leader>p "+p

" Quickfix Logic 
function! ToggleQuickfix()
    let qf_winid = getqflist({'winid' : 0}).winid
    if qf_winid != 0
        cclose
    else
        copen
    endif
endfunction

nnoremap <silent> <A-c> :call ToggleQuickfix()<CR>
nmap <A-d> :cn <cr>zzzv
nmap <A-u> :cp <cr>zzzv

" Window Navigation (Alt + hjkl) 
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-l> <C-w>l
tnoremap <silent> <A-h> <C-\><C-N><C-w>h
tnoremap <silent> <A-j> <C-\><C-N><C-w>j
tnoremap <silent> <A-k> <C-\><C-N><C-w>k
tnoremap <silent> <A-l> <C-\><C-N><C-w>l

" Copy current filename 
nnoremap <silent> cp :let @+ = expand("%")<CR>

" Readonly convenience mappings 
augroup ReadOnlyMappings
    autocmd!
    autocmd BufWinEnter,FileType * if &readonly || !&modifiable |
        \ nnoremap <buffer> <silent> d <C-d>zz |
        \ nnoremap <buffer> <silent> u <C-u>zz |
        \ nnoremap <buffer> <silent> q :q<CR> |
        \ endif
augroup END
