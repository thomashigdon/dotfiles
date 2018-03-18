set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mhinz/vim-signify'
Plugin 'vim-scripts/genutils'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'mbbill/undotree'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Shougo/unite.vim'
Plugin 'devjoe/vim-codequery'
Plugin 'mileszs/ack.vim'
Plugin 'majutsushi/tagbar'
Plugin 'benmills/vimux'
Plugin 'tpope/vim-sleuth'
Plugin 'rkitover/vimpager'
Plugin 'jeaye/color_coded'
Plugin 'brookhong/cscope.vim'
Plugin 'jeetsukumaran/vim-buffergator'

if filereadable("/usr/bin/p4")
    Plugin 'idbrii/vim-perforce'
endif

call vundle#end()            " required
filetype plugin indent on    " required


" Highlight search patterns
set hlsearch
set incsearch
set showmatch

" Folding stuff
set foldmethod=indent
set nofoldenable
set foldlevel=1

" Insert enter when enter is pressed in command mode
"map <S-Enter> O<ESC>
"map <Enter> o<ESC>

" Ctrl-h and Ctrl-i can move in insert mode
imap <C-h> <ESC>hi
imap <C-l> <ESC>li

set scroll=4

" Sensible backspace behavior in insert mode
set bs=2

set nocp

" tab stuff (tabs are spaces, tabs are two spaces)
set ts=2
set expandtab
set shiftwidth=2
set autoindent

au FileType python setl shiftwidth=4 tabstop=4

" Set windows to not automatically equalize when opening a new one
set noequalalways

" Set working directory to the current buffer
"autocmd BufEnter * lcd %:p:h
"set autochdir

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

syntax enable
filetype off
filetype plugin indent on
set nocompatible

set t_Co=16
""set background=dark
"let g:solarized_degrade=1
"let g:solarized_termcolors=16
let g:solarized_termtrans = 1
"let g:solarized_contrast="high"
let g:solarized_termcolors=16 " color depth
let g:solarized_termtrans=0 " 1|0 background transparent
let g:solarized_bold=1 " 1|0 show bold fonts
let g:solarized_italic=1 " 1|0 show italic fonts
let g:solarized_underline=1 " 1|0 show underlines
let g:solarized_contrast="normal" " normal|high|low contrast
let g:solarized_visibility="normal " " normal|high|low effect on whitespace characters
set background=dark
colorscheme solarized

autocmd Syntax * syn match ExtraWhitespace /\s\+$/

set shellslash
set grepprg=grep\ -nH\ $*

" ignores case unless a capital letter is used in the pattern
set ignorecase
set scs

" custom command to open both the .cc and .hh file simultaneously
" in different panes in a new tab (doesn't work yet)
:function! Openboth(truncated_name)
: execute "normal tabnew ".a:truncated_name.cc
: execute "normal sp ".a:truncated_name.hh
:endfunction
:command! -nargs=1 Tboth :call Openboth("<args>")

" Vim will search for the file named 'tags', starting with the
" current directory and then going to the parent directory and then
" recursively to the directory one level above, till it either
" locates the 'tags' file or reaches the root '/' directory.
set tags=tags;/

" mouse scroll wheel stuff (works in screen, yay)
set mouse=a
if ! has('nvim-0.1.5')
  set ttymouse=xterm2
endif
:map <M-Esc>[62~ <MouseDown>
:map! <M-Esc>[62~ <MouseDown>
:map <M-Esc>[63~ <MouseUp>
:map! <M-Esc>[63~ <MouseUp>
:map <M-Esc>[64~ <S-MouseDown>
:map! <M-Esc>[64~ <S-MouseDown>
:map <M-Esc>[65~ <S-MouseUp>
:map! <M-Esc>[65~ <S-MouseUp>

" Open new tab instead of new window
map <C-W>] <C-W>]:tab split<CR>gT:q<CR>gt

" Set number of lines to scroll with C-d and C-u to a smaller value
set scroll=8

" Set the status line to always be displayed
set laststatus=2

" Format the status line
set statusline=%<%F%h%m%r%h%w\ lin:%l\,%L\ col:%c%V\ pos:%o\ %P

" N<C-D> and N<C-U> idiotically change the scroll setting
function! s:Saving_scroll(cmd)
  let save_scroll = &scroll

  execute "normal" a:cmd
  let &scroll = save_scroll
endfunction

" move and scroll
nmap <C-J>      :call <SID>Saving_scroll("1<C-V><C-D>")<CR>
vmap <C-J> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-D>")<CR>
nmap <C-K>      :call <SID>Saving_scroll("1<C-V><C-U>")<CR>
vmap <C-K> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-U>")<CR>

" set list listchars=trail:_
" highlight SpecialKey ctermfg=DarkGray ctermbg=yellow

" To use vim as a man pager
let $PAGER=''

let Tlist_Inc_Winwidth=0

" Perforce integration
"nnoremap @p4a :!p4 add %:e
"nnoremap @p4e :!p4 edit %:e
"nnoremap @p4d :!p4 diff %

" \* does a file search for word under cursor
" doesn't work currently
map \* "syiw:Grep^Rs<CR>
function! Grep(name)
  let l:pattern = input("Other pttern: ")
  echo "here"
  let l:list=system("grep -nIR '".a:name."' * | grep -v 'svn-base' | grep '" .l:pattern. "' | cat -n -")
  echo "here 2"
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return

  endif

  echo l:list
  let l:input=input("Which?\n")

  if strlen(l:input)==0
    return
  endif

  if strlen(substitute(l:input, "[0-9]", "", "g"))>0
    echo "Not a number"
    return
  endif

  if l:input<1 || l:input>l:num
    echo "Out of range"
    return
  endif

  let l:line=matchstr("\n".l:list, "".l:input."\t[^\n]*")
  let l:lineno=matchstr(l:line,":[0-9]*:")
  let l:lineno=substitute(l:lineno,":","","g")

  "echo "".l:line
  let l:line=substitute(l:line, "^[^\t]*\t", "", "")
  "echo "".l:line
  let l:line=substitute(l:line, "\:.*", "", "")
  echo "".l:line
  "echo "\n".l:line
  execute ":e ".l:line
  execute "normal ".l:lineno."gg"

endfunction
command! -nargs=1 Grep :call Grep("<args>")


" ConqueTerm
map \s :ConqueTermSplit bash<CR>

" omni completion
filetype plugin on
set ofu=syntaxcomplete#Complete

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp

" " build tags of your own project with Ctrl-F12
 map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" man pages
runtime ftplugin/man.vim

" from http://www.fefe.de/muttfaq/faq.html
" remove signatures when replying in mutt
au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L

" Toggle mode allowing x-style pastes in a terminal.
set pastetoggle=<F2>

set encoding=utf-8
" Have the search results not be at the top or bottom of the screen.
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
set undofile

let mapleader = ","

nnoremap / /\v
vnoremap / /\v

" Use g in replacements by default
set gdefault

nnoremap <leader><space> :noh<cr>

set wrap
set textwidth=73
set formatoptions=qrn1
set colorcolumn=73

nnoremap ; :

au FocusLost * :wa

"" set jj to be escape
inoremap jj <ESC>

map <leader>rp :VimuxPromptCommand<CR>
map <leader>rl :VimuxRunLastCommand<CR>
map <leader>rq :VimuxCloseRunner<CR>

"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
"set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim

let g:signify_vcs_list = [ 'perforce', 'git' ]
"let g:signify_line_highlight = 1

"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_log_level = 'debug'
let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_confirm_extra_conf = 0

let g:perforce_open_on_change = 1

" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
hi clear SignColumn

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Use the solarized theme for the Airline status bar
let g:airline_theme='solarized'

map <Leader>n <plug>NERDTreeTabsToggle<CR>
map <Leader>m <plug>NERDTreeTabsFind<CR>

"let g:nerdtree_tabs_open_on_console_startup = 1
map <C-n> :NERDTreeToggle<CR>
let g:nerdtree_tabs_autofind = 1

nmap <F8> :TagbarToggle<CR>

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)

" FB configerator filetypes
autocmd BufEnter *.cinc :setlocal filetype=python
autocmd BufEnter *.cconf :setlocal filetype=python
autocmd BufEnter *.mcconf :setlocal filetype=python
autocmd BufEnter *.tw :setlocal filetype=python
autocmd BufEnter *.materialized_JSON :setlocal filetype=json

" CamelCase and under_score motion
Plugin 'bkad/CamelCaseMotion'
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

Plugin 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plugin 'tpope/vim-jdaddy'

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 1
endif

"au BufReadPost quickfix map <buffer> <Enter> :.cc<CR>
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

Plugin 'yssl/QFEnter'

" tabs/buffers experiment
set hidden
" Shortcut for moving through tabs
map <S-h> :bprevious<CR>
map <S-l> :bnext<CR>

" YCM must use the same Python version it's linked against
let g:ycm_path_to_python_interpreter = '/data/users/tph/fbsource/fbcode/third-party-buck/gcc-5-glibc-2.23/build/python/2.7/bin/python2.7'
