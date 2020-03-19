set nocompatible              " be iMproved, required
let mapleader = ","

"Plug 'ervandew/supertab'
call plug#begin('~/.vim/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'altercation/vim-colors-solarized'
Plug 'mhinz/vim-signify'
Plug 'vim-scripts/genutils'
Plug 'scrooloose/nerdtree'
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>m :NERDTreeFind<CR>
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'benmills/vimux'
Plug 'tpope/vim-sleuth'
Plug 'kana/vim-altr'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

Plug 'christoomey/vim-tmux-navigator'

"Plug 'octol/vim-cpp-enhanced-highlight'
" Syntax highlighting
"Plug 'bbchung/Clamp'
"Plug 'nixprime/cpsm'

"Plug 'natebosch/vim-lsc'
"let g:lsc_server_commands = { 
"      \'cpp': '/home/tph/src/cquery/build/release/bin/cquery --log-file=/tmp/cq.log --init=''{"cacheDirectory" : "/tmp/cquery-mine"}'''
"      \ }
"
"let g:lsc_auto_map = {
"    \ 'GoToDefinition': 'gd',
"    \ 'FindReferences': 'gr',
"    \ 'NextReference': '<C-n>',
"    \ 'PreviousReference': '<C-p>',
"    \ 'FindImplementations': 'gI',
"    \ 'FindCodeActions': 'ga',
"    \ 'DocumentSymbol': 'go',
"    \ 'WorkspaceSymbol': 'gS',
"    \ 'ShowHover': 'gh',
"    \ 'Completion': 'completefunc',
"    \}
"let g:lsc_trace_level = 'verbose'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'pdavydov108/vim-lsp-cquery'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gD :LspCqueryDerived<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gc :LspCqueryCallers<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gb :LspCqueryBase<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gv :LspCqueryVars<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gd :LspDefinition<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gr :LspReferences<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp,python nnoremap <silent> gh :LspHover<CR>
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
let g:asyncomplete_log_file = expand('~/vim-asyncomplete.log')

au User lsp_setup call lsp#register_server({
  \ 'name': 'cquery',
  \ 'cmd': {server_info->['/home/tph/src/cquery/cquery.real', '--log-file=/tmp/cq.log']},
  \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
  \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery-mine', 'cacheFormat' : 'msgpack' },
  \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
  \ })
"      \ 'cmd': {server_info->['/bin/cquery', '--log-file=/tmp/cq.log']},

if executable('pyls')
 au User lsp_setup call lsp#register_server({
				 \ 'name': 'pyls',
				 \ 'cmd': {server_info->['pyls', '--log-file=/home/tph/pyls.log']},
				 \ 'whitelist': ['python'],
				 \ })
endif

"Plug 'autozimu/LanguageClient-neovim', {
" \ 'branch': 'next',
" \ 'do': 'bash install.sh',
" \ }
"let g:LanguageClient_serverCommands = {
"    \ 'cpp' : ['/home/tph/src/cquery/build/release/bin/cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory" : "/tmp/cquery-mine"}'],
"    \ 'python' : ['pyls', '--log-file=/home/tph/pyls.log'],
"    \ }
"
""    \ 'cpp' : ['/bin/cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory" : "/tmp/cquery-fb"}'],
"let g:LanguageClient_loadSettings = 1
"let g:LanguageClient_settingsPath = '/home/tph/.config/nvim/settings.json'
"set completefunc=LanguageClient#complete
"set formatexpr=LanguageClient_textDocument_rangeFormatting()
"
"
"nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
"nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
"nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
"nnoremap <silent> gi :call LanguageClient#textDocument_implementation()<CR>
"nnoremap <silent> gD :call LanguageClient#cquery_dervied()<CR>
"nnoremap <silent> <F3> :call LanguageClient_textDocument_rename()<CR>
"
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
"let $FZF_DEFAULT_COMMAND="fd . 'fbcode/' 'configerator/' 'kernel/' "
"command! MyShit call fzf#run(fzf#wrap({'source': 'fd-order '.expand('%'), 'sink': 'e'}))
command! FilesOrdered call fzf#run(fzf#wrap(
      \ {'source': 'fd-order --infile='.expand('%'), 'options': '--tiebreak=index'}))
command! FilesOrderedRefresh call fzf#run(fzf#wrap(
      \ {'source': 'fd-order --force-refresh --infile='.expand('%'), 'options': '--tiebreak=index'}))
"Plug 'Shougo/deoplete.nvim'
"uuk
"let g:deoplete#enable_at_startup = 1

"Plug 'lyuts/vim-rtags'

if filereadable("$ADMIN_SCRIPTS/master.vimrc")
  source $ADMIN_SCRIPTS/master.vimrc
else
  au FileType python setl shiftwidth=4 tabstop=4
  " tab stuff (tabs are spaces, tabs are two spaces)
  set ts=2
  set expandtab
  set shiftwidth=2
  set autoindent
endif

" Highlight search patterns
set hlsearch
set incsearch
set showmatch

" Folding stuff
set foldmethod=indent
set nofoldenable
set foldlevel=1

" Insert enter when enter is pressed in command mode
map <S-Enter> O<ESC>
map <Enter> o<ESC>

set scroll=4

" Sensible backspace behavior in insert mode
set bs=2

set nocp

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

"set t_Co=256
"set background=dark
"let g:solarized_degrade=1
"let g:solarized_termcolors=16
let g:solarized_termtrans = 1
"let g:solarized_contrast="high"
let g:solarized_termcolors=16 " color depth
let g:solarized_termtrans=0 " 1|0 background transparent
let g:solarized_bold=1 " 1|0 show bold fonts
let g:solarized_italic=1 " 1|0 show italic fonts
let g:solarized_underline=1 " 1|0 show underlines
let g:solarized_contrast="high" " normal|high|low contrast
let g:solarized_visibility="normal " " normal|high|low effect on whitespace characters
set background=dark

autocmd Syntax * syn match ExtraWhitespace /\s\+$/

set shellslash
set grepprg=grep\ -nH\ $*

" ignores case unless a capital letter is used in the pattern
set ignorecase
set scs

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
"nmap <C-J>      :call <SID>Saving_scroll("1<C-V><C-D>")<CR>
"vmap <C-J> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-D>")<CR>
"nmap <C-K>      :call <SID>Saving_scroll("1<C-V><C-U>")<CR>
"vmap <C-K> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-U>")<CR>

" set list listchars=trail:_
" highlight SpecialKey ctermfg=DarkGray ctermbg=yellow

" To use vim as a man pager
"let $PAGER=''

let Tlist_Inc_Winwidth=0

" Perforce integration
"nnoremap @p4a :!p4 add %:e
"nnoremap @p4e :!p4 edit %:e
"nnoremap @p4d :!p4 diff %

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp

" " build tags of your own project with Ctrl-F12
 map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" man pages
runtime ftplugin/man.vim

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

let g:signify_vcs_list = [ 'hg', 'git' ]
let g:signify_line_highlight = 0

let g:ycm_global_ycm_extra_conf = '/home/tph/.vim/bundle/YouCompleteMe/ycm_extra_conf_fbcode.py'

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

Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plug 'tpope/vim-jdaddy'

"au BufReadPost quickfix map <buffer> <Enter> :.cc<CR>
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

Plug 'yssl/QFEnter'
call plug#end()

" tabs/buffers experiment
set hidden
" Shortcut for moving through tabs
map <S-h> :bprevious<CR>
map <S-l> :bnext<CR>

" Skip quickfix for bnext bprevious
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

nnoremap <leader>F :FBGS <C-R><C-W><CR>:cw<CR>
nnoremap <leader>C :CBGS <C-R><C-W><CR>:cw<CR>
nnoremap <leader>T :TBGS <C-R><C-W><CR>:cw<CR>
nnoremap <leader>K :KBGS <C-R><C-W><CR>:cw<CR>

set path+=/home/tph/fbcode,/home/tph/configerator,/home/tph/kernel,/home/tph/www

nmap <leader>f :FilesOrdered<cr>
nmap <leader>g :FilesOrdered<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>h :History<cr>

" YCM must use the same Python version it's linked against
let g:ycm_path_to_python_interpreter = '/data/users/tph/fbsource/fbcode/third-party-buck/gcc-5-glibc-2.23/build/python/2.7/bin/python2.7'

if filereadable("$HOME/.vim/bundle/biggrep.vim")
  source $HOME/.vim/bundle/biggrep.vim
endif

" copy to attached terminal using the yank(1) script:
"noremap <silent> y y:call system("echo -n " . getreg("\"") . " \| rpbcopy")<Return>

" altr plugin (for alternate buffers)
nmap <leader>a <Plug>(altr-forward)
nmap <leader>s <Plug>(altr-back)
call altr#define('%.h', '%.cpp', '%-inl.h')
colorscheme solarized
