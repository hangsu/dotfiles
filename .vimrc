"-------------------------------------------
" MAPPINGS
"-------------------------------------------

let mapleader = ','
" using map for showcmd
map <Space> <Leader>

" visual movement
nmap j gj
nmap k gk

" map Y to behave like C and D
nnoremap Y y$ 

" clear search highlight
nnoremap <silent> <CR> :nohl<CR>

" window management
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" fuzzy file finder
nnoremap <C-p> :Files<CR>

" file explorer
nnoremap <Leader>e :NERDTreeToggle<CR>
nnoremap <Leader>E :NERDTreeFind<CR>

" rename
nnoremap <Leader>r :Move <C-r>%

" edit vimrc
nnoremap <Leader>, :e $MYVIMRC<CR>

" indent file
nnoremap <Leader>= gg=G<C-o><C-o>

"-------------------------------------------
" PLUGINS
"-------------------------------------------

" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" Avoid using standard Vim directory names like 'plugin'
" Install: `:PlugInstall`
" Update: `:PlugUpdate`
" Remove unused: `:PlugClean`
" Upgrade vim-plug: `:PlugUpgrade`
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'

" Colors
Plug 'lifepillar/vim-solarized8'
call plug#end()

"-------------------------------------------
" SETTINGS
"-------------------------------------------

" basic
set hidden
set history=1000
set cursorline
set backspace=indent,eol,start
set ruler
set laststatus=2
set showcmd
set showmatch
set wildmenu
set scrolloff=10
set sidescrolloff=10
set winwidth=79
set formatoptions+=j " Delete comment character when joining commented lines
set autoread
set noshowmode
set titlestring=%{getcwd()}
set shortmess+=A " disable swap file alerts
set splitbelow
set splitright

" filtype & syntax
syntax enable
filetype plugin indent on

" backups, swap & persistent undo
set nobackup
set nowritebackup
set undofile
if !isdirectory($HOME . "/.vim/undo")
  call mkdir($HOME . "/.vim/undo", "p")
endif
set undodir=~/.vim/undo//
if !isdirectory($HOME . "/.vim/swp")
  call mkdir($HOME . "/.vim/swp", "p")
endif
set directory=~/.vim/swp// " put swap files in one place

" search
set incsearch
set hlsearch
set ignorecase smartcase

" tabbing & indentation
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

" gui-only
if has('gui_running')
  colorscheme solarized8 " use terminal colors if not gui
  set background=dark
  set guifont=Menlo:h14
  set guitablabel=%{getcwd()}
  set linespace=2
endif

"-------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------
augroup vimStartup
  au!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

"-------------------------------------------
" NERDTree
"-------------------------------------------

let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeMouseMode=2 " single click to open directories
let NERDTreeAutoDeleteBuffer=1
let NERDTreeWinSize=31

"-------------------------------------------
" lightline
"-------------------------------------------

let g:lightline = {
      \   'colorscheme': 'solarized',
      \   'active': {
      \     'left': [['mode', 'paste'], ['relativepath', 'modified']],
      \     'right': [['lineinfo'], ['gitbranch'], ['readonly', 'fileencoding', 'filetype']]
      \   },
      \   'inactive': {
      \     'left': [['relativepath']],
      \     'right': [['lineinfo']]
      \   },
      \   'component_function': {
      \     'gitbranch': 'fugitive#head',
      \   },
      \ }

command! LightlineReload call LightlineReload()

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

"-------------------------------------------
" Goyo
"-------------------------------------------

function! s:goyo_enter()
  set nocursorline
  set background=light
  set linebreak
  if has('gui_running')
    set linespace=7
  endif
endfunction

function! s:goyo_leave()
  set cursorline
  set background=dark
  set linebreak&
  if has('gui_running')
    set linespace&
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
