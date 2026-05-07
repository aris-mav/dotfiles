" --- Map leader to space ---
let mapleader = " "
let maplocalleader = "\\"

" --- General Keymaps ---
nnoremap <C-q> :q<CR>
nnoremap <leader>q :q<CR>
nmap <leader>w :w <cr>
nmap <leader>e :Ex<cr>
nmap <leader>b :buffers<cr>:b<space> 
nmap <leader>m :marks<cr>

" --- Keeping cursor centered ---
nmap n nzzzv
nmap N Nzzzv
nmap <C-d> <C-d>zzzv
nmap <C-u> <C-u>zzzv

" --- Redo ---
nnoremap U <C-r>

" --- Clipboard Copy/Paste ---
" Yank to + register
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" Paste from + register
nnoremap <leader>p "+p
vnoremap <leader>p "+p

" --- Quickfix Logic ---
function! ToggleQuickfix()
    let qf_winid = getqflist({'winid' : 0}).winid
    if qf_winid != 0
        cclose
    else
        copen
    endif
endfunction

nnoremap <silent> <A-c> :call ToggleQuickfix()<CR>
nmap <C-n> :cn <cr>zzzv
nmap <C-p> :cp <cr>zzzv

" --- Window Navigation (Alt + hjkl) ---
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-l> <C-w>l

" Terminal mode window navigation
tnoremap <silent> <A-h> <C-\><C-N><C-w>h
tnoremap <silent> <A-j> <C-\><C-N><C-w>j
tnoremap <silent> <A-k> <C-\><C-N><C-w>k
tnoremap <silent> <A-l> <C-\><C-N><C-w>l

" --- DOI Opener (gx) ---
function! OpenDOI()
    let l:word = expand("<cWORD>")
    " Strip surrounding brackets/parens
    let l:clean = substitute(l:word, '^(\|)$', '', 'g')
    let l:clean = substitute(l:clean, '^\[\|\]$', '', 'g')
    
    " Extract DOI pattern
    let l:doi = matchstr(l:clean, '10\.\d\+/\S\+[^)\]\}\s]')
    if !empty(l:doi)
        " Remove trailing dots
        let l:doi = substitute(l:doi, '\.\+$', '', '')
        let l:url = "https://doi.org/" . l:doi
        " Use job_start (Vim 8+) for async opening
        call job_start(["xdg-open", l:url])
    else
        " Fallback to default gx behavior
        normal! gx
    endif
endfunction

nnoremap <silent> gx :call OpenDOI()<CR>

" --- Markdown Preview ---
augroup MarkdownMaps
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <silent> gp :w<CR>:!~/.config/scripts/nt.sh -p %:p<CR>
augroup END

" --- Copy filename ---
nnoremap <silent> cp :let @+ = expand("%")<CR> 
