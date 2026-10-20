let mapleader = " "
let maplocalleader = "\\"

nmap <leader>w :write<cr>
nmap <leader>e :Explore<cr>
nmap <leader>b :buffers<cr>
nmap <leader>m :marks<cr>
nmap <leader>f :find *
nmap <leader>/ :grep<space>

xnoremap < <gv
xnoremap > >gv

nnoremap U <C-r>

nnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>y "+y
xnoremap <leader>p "+p

function! ToggleQuickfix()
    if getqflist({'winid' : 0}).winid
        cclose
    else
        copen
    endif
endfunction
nnoremap <silent> <leader>q :call ToggleQuickfix()<CR>

nnoremap <silent> ]q :<C-u>execute v:count1 . 'cnext'<cr>
nnoremap <silent> [q :<C-u>execute v:count1 . 'cprevious'<cr>
nnoremap <silent> ]l :<C-u>execute v:count1 . 'lnext'<cr>
nnoremap <silent> [l :<C-u>execute v:count1 . 'lprevious'<cr>
nnoremap <silent> ]a :<C-u>execute v:count1 . 'next'<cr>
nnoremap <silent> [a :<C-u>execute v:count1 . 'previous'<cr>
nnoremap <silent> ]b :<C-u>execute v:count1 . 'bnext'<cr>
nnoremap <silent> [b :<C-u>execute v:count1 . 'bprevious'<cr>

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

augroup ReadOnlyMappings
    autocmd!
    autocmd BufWinEnter,FileType * if &readonly || !&modifiable |
        \ nnoremap <buffer> <silent> d <C-d>zz |
        \ nnoremap <buffer> <silent> u <C-u>zz |
        \ nnoremap <buffer> <silent> q :q<CR> |
        \ endif
augroup END

augroup NetrwMappings
    autocmd!
    autocmd FileType netrw nmap <buffer> l <CR>
    autocmd FileType netrw nmap <buffer> h -
augroup END
