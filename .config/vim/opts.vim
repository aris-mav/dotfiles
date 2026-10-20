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
set mouse=a
set sidescrolloff=2
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set termguicolors
set background=dark
set timeoutlen=750
set ttimeoutlen=10
set number
set relativenumber
set fillchars+=vert:\ 
set fillchars+=eob:\ 
set shell=fish

if executable('rg')
    set grepprg=rg\ -S\ --vimgrep
    set grepformat=%f:%l:%c:%m
else
    set grepprg=grep\ -nH\ $*
    set grepformat=%f:%l:%m
endif

let &t_SI = "\e[6 q" " SI = Start Insert (Vertical bar)
let &t_SR = "\e[4 q" " SR = Start Replace (Underline)
let &t_EI = "\e[2 q" " EI = End Insert/Replace (Block)

let g:netrw_banner = 0
let g:netrw_preview = 1
let g:netrw_winsize = 30

augroup CmdModeNumbers
    autocmd!
    autocmd CmdlineEnter : set norelativenumber | redraw
    autocmd CmdlineLeave : set relativenumber
augroup END

augroup NetrwSettings
    autocmd!
    autocmd FileType netrw setlocal number relativenumber
augroup END

augroup TabSettings
    autocmd!
    autocmd FileType csv,tsv,txt setlocal noexpandtab tabstop=4
augroup END

augroup SpellCheckTextFiles
  autocmd!
  autocmd FileType markdown,tex,text,typst
        \ setlocal spell spelllang=en_gb,el textwidth=50 colorcolumn=+1
augroup END
