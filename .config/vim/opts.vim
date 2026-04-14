syntax on          
filetype plugin indent on

set hidden             " Allow switching buffers without saving
set mouse=a            " Enable mouse support (useful for resizing splits)
set splitbelow         " Horizontal splits open below
set splitright         " Vertical splits open to the right
set confirm            " Ask to save instead of failing a :q command

" --- colour ---
set background=dark
colorscheme retrobox

" --- Line numbers ---
set relativenumber
set number

" Change cursor shape for different modes
let &t_SI = "\e[6 q" " SI = Start Insert (Vertical bar)
let &t_SR = "\e[4 q" " SR = Start Replace (Underline)
let &t_EI = "\e[2 q" " EI = End Insert/Replace (Block)
set timeoutlen=500    " Timeout for mapping sequences
set ttimeoutlen=10    " Timeout for terminal key codes (this fixes the Esc delay)

" --- Remove border and end-of-file tildes ---
set fillchars+=vert:\ 
set fillchars+=eob:\ 

" --- Tab settings ---
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

" Case-specific tab settings
augroup TabSettings
    autocmd!
    autocmd FileType csv,tsv,txt setlocal noexpandtab tabstop=4
augroup END

" --- Readonly convenience mappings ---
augroup ReadOnlyMappings
    autocmd!
    autocmd BufWinEnter,FileType * if &readonly || !&modifiable |
        \ nnoremap <buffer> <silent> d <C-d>zz |
        \ nnoremap <buffer> <silent> u <C-u>zz |
        \ nnoremap <buffer> <silent> q :q<CR> |
        \ endif
augroup END

" --- Dynamic colorcolumn ---
augroup ColumnLine
    autocmd!
    autocmd FileType,VimResized,WinEnter * call SetDynamicColumn()
augroup END

function! SetDynamicColumn()
    let l:cols = winwidth(0)
    if &filetype == 'markdown' && l:cols > 70
        setlocal colorcolumn=50
    elseif l:cols > 100
        setlocal colorcolumn=80
    else
        setlocal colorcolumn=
    endif
endfunction

" --- Language / Keymap ---
set keymap=greek
set iminsert=0

" --- Grep with Ripgrep ---
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
else
    set grepprg=grep\ -nH\ $*
    set grepformat=%f:%l:%m
endif

" Abbreviations for command line
cnoreabbrev <expr> g (getcmdtype() == ':' && getcmdline() == 'g') ? 'silent grep' : 'g'

" --- Search and UI ---
set nohlsearch
set incsearch
set scrolloff=1
set sidescrolloff=2
let g:netrw_banner = 0
" set clipboard=unnamedplus

" --- Writing / Spellcheck ---
augroup SpellCheckForSpecificFiletypes
    autocmd!
    autocmd FileType markdown,tex,txt,typst 
        \ setlocal spelllang=en_gb,el |
        \ setlocal spell |
        \ setlocal textwidth=50
augroup END

" --- General behavior ---
set nowrap
set undofile
set ignorecase
set smartcase

" --- Terminal settings (Vim-specific) ---
augroup custom-term-open
    autocmd!
    autocmd TerminalOpen * setlocal signcolumn=no nonumber norelativenumber
augroup END
