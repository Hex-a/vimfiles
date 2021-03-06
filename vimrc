" vim: set foldmethod=marker foldlevel=0:
" ----------------------------------------------------------------------------
 
let $VIMFILES='.vim'
if has('win32')
  let $VIMFILES='vimfiles'
  cd $HOME/Documents
end

" ----------------------------------------------------------------------------
" PLUGINS {{{
" ----------------------------------------------------------------------------

set nocompatible
filetype off

set rtp+=$HOME/$VIMFILES/bundle/vundle/

call vundle#begin()

Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Rip-Rip/clang_complete.git'
Plugin 'vim-scripts/SearchComplete'
Plugin 'leafgarland/typescript-vim'
Plugin 'noahfrederick/vim-hemisu'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'chriskempson/base16-vim'
Plugin 'itchyny/lightline.vim'
Plugin 'msanders/snipmate.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'widatama/vim-phoenix'
Plugin 'jnwhiteh/vim-golang'
Plugin 'kikijump/tslime.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Shougo/vimproc.vim'
Plugin 'tmhedberg/matchit'
Plugin 'Quramy/tsuquyomi'
Plugin 'isRuslan/vim-es6'
Plugin 'mattn/emmet-vim'
Plugin 'nvie/vim-flake8'
Plugin 'kien/ctrlp.vim'
Plugin 'wting/rust.vim'
Plugin 'gmarik/Vundle'
Plugin 'gmarik/vundle'
Plugin 'fatih/vim-go'
Plugin 'sjl/badwolf'

call vundle#end()
filetype plugin indent on 
syntax on

" }}}

" ----------------------------------------------------------------------------
" SETTINGS {{{
" ----------------------------------------------------------------------------

" General
set wildmenu
set history=1000
set lazyredraw " redraw the screen only if something is typed
set termencoding=utf-8
set encoding=utf-8
set hidden
set number 
set smartcase 
set title 
set hlsearch
set incsearch
set nobackup
set noswapfile
set textwidth=78
set shortmess=aoOstTwWAI
set foldmethod=syntax
set laststatus=2
set spellsuggest=fast,10
set scrolloff=8
set cursorline
set backspace=indent,eol,start
set hidden
set autoread
set clipboard=unnamed "use '*' as bridge to system clipboard

" Indentation
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

set guicursor+=a:blinkon0

" GUI
set go=-m
set go=-t
set background=dark

set spell spelllang=en_us,pt
set spell!

set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

if exists('&colorcolumn')
    set colorcolumn=80
endif

" Specificities
if has('win32') 
  set guifont=Consolas\ for\ Powerline\ FixedD:h9
  set lines=60
end

if has('X11')
    set columns=90
   " set guifont=MesloLG\ L\ DZ\ for\ Powerline\ 10
    set guifont=Menlo\ Medium\ 10
endif

if $COLORTERM == "gnome-terminal"
    set t_Co=256
    colorscheme jellybeans
else 
    " colorscheme base16-eighties
    colorscheme badwolf
endif

" colorscheme hemisu
" colorscheme solarized
" colorscheme phoenix
" colorscheme jellybeans

set re=1 " Fixes slow rendering when editing ruby files

"}}}

" ----------------------------------------------------------------------------
" KEYBINDINGS {{{
" ----------------------------------------------------------------------------

command! Bp :bp|bd# 

let mapleader = "\<space>"

inoremap jk <esc>

nnoremap <F2> :set spell!<cr>
nnoremap <F3> :set hlsearch!<cr>

nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>r :w <cr> :source %<cr>

nnoremap <C-k> :silent! move-2<CR>
nnoremap <C-j> :silent! move+<CR>
nnoremap Q @q

nnoremap <C-Tab> :bn<cr>
nnoremap <C-left> :vertical resize +5<cr>
nnoremap <C-right> :vertical resize -5<cr>
nnoremap <C-down> :resize -5<cr>
nnoremap <C-up> :resize +5<cr>

" enable to jump to a window n when <M-n> is pressed
for x in range(1,10)
    execute "nnoremap <silent><M-".x."> :".x."wincmd w<CR>"
    execute "nnoremap <silent><leader>t".x." ".x."gt"
endfor

if has('win32')
    nnoremap <F12> :e $HOME/_vimrc<cr>
else
    nnoremap <F12> :e $HOME/.vimrc<cr>
end

au Filetype go nnoremap <leader>ii :GoImport 
au Filetype go nnoremap <leader>id :GoDrop  
au Filetype go nnoremap <leader>r :GoRun<cr>
" }}}

" ----------------------------------------------------------------------------'
" HOOKS {{{
" ----------------------------------------------------------------------------'

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" }}}

" ----------------------------------------------------------------------------
" LIGHT LINE {{{
" ----------------------------------------------------------------------------
let g:lightline = {
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

" some of the terminals I usually work with don't use fonts that support
" powerbar special symbols. So, I'm turning them off to avoid gibberish 
" on the status bar 
if !has("gui_running") || 1
    call remove(g:lightline, 'separator') " unlet could be used too
    call remove(g:lightline, 'subseparator')
endif

let g:lightline.colorscheme = 'powerline'

" }}}

" ----------------------------------------------------------------------------
" MY INLINE PLUGINS {{{
" ----------------------------------------------------------------------------

let s:ScratchBufName = "__scratch__"

fun! ScratchOnLeave()
    let l:winNum = bufwinnr(s:ScratchBufName)
    exec l:winNum . "wincmd c"
endfu

fun! ScratchToggle() 
    let l:winNum = bufwinnr(s:ScratchBufName)
    if l:winNum != -1
        if l:winNum == winnr()
            :q
            return
        endif
        execute l:winNum . "wincmd w"
        return
    endif

    if bufexists(s:ScratchBufName)
        :sp __scratch__
        return 
    endif

    exec "new __scratch__"
    exec "setlocal hidden"
    exec "setlocal buftype=nofile"
    exec "setlocal nobuflisted"
    exec "au BufLeave <buffer> call ScratchOnLeave()"
endfunction

command! Scratch call ScratchToggle()
nnoremap <tab> :Scratch<cr>

fun! Jprettify ()
    :1,$!cmd /c D:\Tools\jq-win64.exe .
endfu

command! JSPrettify call Jprettify()

"}}}
