"-------------------------------------------
" MAPPINGS
"-------------------------------------------

" using map for showcmd
let mapleader = ','

" map Y to behave like C and D
nnoremap Y y$ 

" allows undo of insert mode ctrl-u & ctrl-w
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" clear search highlight
nnoremap <cr> :nohlsearch<cr><cr>

" window management
nnoremap <c-c> :Bd<cr>
nnoremap <c-s> :w<cr>
nnoremap <c-n> :enew<cr>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" search
nnoremap <c-f> /\v
xnoremap <c-f> y/\v"<c-r>0"

" grep
nnoremap <c-g> :call GrepPrompt()<cr>
xnoremap <c-g> y:Gr "<c-r>0"

" smart autocomplete <tab>
inoremap <expr> <tab> InsertSmartTab()
inoremap <s-tab> <c-n>

" fuzzy finder
nnoremap <c-p> :Files<cr>
nnoremap <tab> :Buffers<cr>

" file explorer
nnoremap <leader>e :NERDTree<cr>
nnoremap <leader>E :NERDTreeFind<cr>

" prose
nnoremap <leader>w :Goyo<cr>

" edit vimrc
nnoremap <leader>, :e $MYVIMRC<cr>

" indent file
nnoremap <leader>= gg=G<c-o><c-o>

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
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'ap/vim-css-color'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'mhinz/vim-grepper'

" Colors
Plug 'lifepillar/vim-solarized8'
Plug 'arcticicestudio/nord-vim'
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
set scrolloff=3
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

" grep
set grepprg=rg\ --vimgrep\ --hidden\ --smart-case\ --no-column

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
else
  colorscheme nord " or whatever the terminal colors are set to
endif

"-------------------------------------------
" CUSTOM COMMANDS
"-------------------------------------------

command! -nargs=1 Gr call Grep(<f-args>)

function! Grep(query)
  execute 'silent grep!' a:query | copen 15
  let list = getqflist()
  let size = len(list)
  if size == 0
    execute 'cclose'
    redraw
    echo 'No matches found'
  else
    redraw
    " highlight results
    let vim_query = a:query
    let start = vim_query[0]
    let end = vim_query[-1:-1]
    if start == end && start =~ "['\"]"
      let vim_query = vim_query[1:-2]
    endif
    let @/ = '\v' . vim_query
    call feedkeys(":set hls\<bar>echo '" . size . " matches'\<cr>", 'n')
    " keys queued by feedkeys runs after function ends so nothing can come after
  endif
endfunction

function! GrepPrompt()
  echohl Question
  call inputsave()
  let query = input(&grepprg . '> ')
  echohl None
  call inputrestore()
  if empty(query)
    redraw!
  else
    call Grep(query)
  endif
endfunction

command! Bd call SmartBd()
function! SmartBd()
  let path = expand('%:t')
  let wininfo = getwininfo(win_getid())[0]
  " close window if its not a file
  if path =~ "NERD_tree" || wininfo.quickfix == 1 || wininfo.terminal == 1 || wininfo.loclist == 1
    execute 'quit'
  else
    " close buffer but not window
    try
      execute 'bp|bd #'
    catch /E516/
      echo "No more buffers"
    endtry
  endif
endfunction

" multipurpose tab key
function! InsertSmartTab()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

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
" FZF
"-------------------------------------------

" use rg to find files
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

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

"-------------------------------------------
" Gitgutter
"-------------------------------------------

let g:gitgutter_diff_base = 'HEAD'
