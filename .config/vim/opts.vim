syntax on          
filetype plugin indent on

set nowrap
set undofile
set ignorecase
set smartcase
set hidden
set splitbelow
set splitright
set confirm
set nohlsearch
set incsearch
set path=.,**
set wildmenu
set wildignore+=**/.git/**,**/build/**
set shell=fish
set mouse=a
set scrolloff=1
set sidescrolloff=2
set relativenumber
set number
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set termguicolors
set background=dark

augroup NetrwSettings
    autocmd!
    autocmd FileType netrw setlocal number relativenumber
augroup END
let g:netrw_banner = 0

" Cursor shape
let &t_SI = "\e[6 q" " SI = Start Insert (Vertical bar)
let &t_SR = "\e[4 q" " SR = Start Replace (Underline)
let &t_EI = "\e[2 q" " EI = End Insert/Replace (Block)

set timeoutlen=500    " Timeout for mapping sequences
set ttimeoutlen=10    " Fixes Esc delay

" Remove border and end-of-file tildes 
set fillchars+=vert:\ 
set fillchars+=eob:\ 

augroup TabSettings
    autocmd!
    autocmd FileType csv,tsv,txt setlocal noexpandtab tabstop=4
augroup END

if executable('rg')
    set grepprg=rg\ -S\ --vimgrep
    set grepformat=%f:%l:%c:%m
else
    set grepprg=grep\ -nH\ $*
    set grepformat=%f:%l:%m
endif

augroup SpellCheckForSpecificFiletypes
  autocmd!
  autocmd FileType markdown,tex,text,typst
        \ setlocal spell spelllang=en_gb,el textwidth=50 colorcolumn=+1
augroup END
