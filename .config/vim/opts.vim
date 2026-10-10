syntax on          
filetype plugin indent on

set nowrap          " Don't wrap long lines
set undofile        " Keep undo history across sessions
set ignorecase      " Case-insensitive search...
set smartcase       " ...unless the pattern has capitals
set hidden          " Allow switching buffers without saving
set mouse=a         " Enable mouse support (useful for resizing splits)
set splitbelow      " Horizontal splits open below
set splitright      " Vertical splits open to the right
set confirm         " Ask to save instead of failing a :q command
set wildmenu        " Display all matching files when tab completing
set path=.,**       " Search the current file's directory and downward

set wildignore+=**/.git/**,**/build/**  " Ignore certain folders

set shell=fish

" colour 
set termguicolors
set background=dark

" Line numbers 
set relativenumber
set number
augroup NetrwSettings
    autocmd!
    autocmd FileType netrw setlocal number relativenumber
augroup END

" Change cursor shape for different modes
let &t_SI = "\e[6 q" " SI = Start Insert (Vertical bar)
let &t_SR = "\e[4 q" " SR = Start Replace (Underline)
let &t_EI = "\e[2 q" " EI = End Insert/Replace (Block)
set timeoutlen=500    " Timeout for mapping sequences
set ttimeoutlen=10    " Timeout for terminal key codes (this fixes the Esc delay)

" Remove border and end-of-file tildes 
set fillchars+=vert:\ 
set fillchars+=eob:\ 

" Tab settings 
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

" Case-specific tab settings
augroup TabSettings
    autocmd!
    autocmd FileType csv,tsv,txt setlocal noexpandtab tabstop=4
augroup END


" Language / Keymap 
set keymap=greek
set iminsert=0

" Grep with Ripgrep 
if executable('rg')
    set grepprg=rg\ -S\ --vimgrep
    set grepformat=%f:%l:%c:%m
else
    set grepprg=grep\ -nH\ $*
    set grepformat=%f:%l:%m
endif

" Search and UI 
set nohlsearch
set incsearch
set scrolloff=1
set sidescrolloff=2
let g:netrw_banner = 0
" set clipboard=unnamedplus

augroup SpellCheckForSpecificFiletypes
  autocmd!
  autocmd FileType markdown,tex,text,typst
        \ setlocal spell spelllang=en_gb,el textwidth=50 colorcolumn=+1
augroup END
