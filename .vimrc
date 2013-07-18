" This must be first, because it changes other options as a side effect.
set nocompatible

" ADDONS
filetype off                   " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kien/ctrlp.vim'

" BASIC
set hidden
set backup
set history=10000
set showcmd
set cursorline
set switchbuf=useopen
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set showmatch
set laststatus=2
set wildmenu
set scrolloff=3
set ttimeout ttimeoutlen=50
set winwidth=79
syntax enable

" SEARCH
set incsearch
set hlsearch
set ignorecase smartcase " make searches case-sensitive only if they contain upper-case characters

" TABBING & INDENTATION
set tabstop=2
set shiftwidth=2 
set softtabstop=2
set expandtab 
set smarttab
set shiftround
set autoindent
filetype plugin indent on

" MAPPINGS
let mapleader=","
map Y y$
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
inoremap <C-U> <C-G>u<C-U>
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" AUTOCOMMANDS
augroup vimrcEx
  autocmd!

  autocmd FileType text setlocal textwidth=78
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

augroup END

" SOLARIZED
set background=dark
colorscheme solarized
