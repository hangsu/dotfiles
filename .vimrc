" This must be first because it changes other options as a side effect.
set nocompatible

""" ADDONS """
""""""""""""""
filetype off " required for vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Plugin 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
filetype plugin indent on

" BASIC
set hidden
set history=100
set cursorline
set switchbuf=useopen
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set laststatus=2
set ruler
set wildmenu
set scrolloff=3
set winwidth=79

" toggles cursor line hilighting upon switching modes
autocmd InsertEnter * set nocul
autocmd InsertLeave * set cul
syntax enable

" NETRW
let g:netrw_liststyle=3
let g:netrw_preview=1
let g:netrw_browse_split=4

" BACKUP
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" SEARCH
set grepprg=ack\ -k
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
set breakindent

" MAPPINGS
let mapleader=","
map Y y$
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
" allows undo of insert mode ctrl-u & ctrl-w
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

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
