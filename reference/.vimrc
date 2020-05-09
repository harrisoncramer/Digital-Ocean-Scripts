syntax on

set nocompatible " required
filetype off " required

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocompletion w/ TS Language server
Plug 'dense-analysis/ale' " Async linting engine
Plug 'jparise/vim-graphql' " Install linting for graphQl
Plug 'w0rp/ale' " Engine for running ESLint...
Plug 'xolox/vim-session' " Better session management (:SaveSession + :OpenSession)
Plug 'xolox/vim-misc' " Necessary to support vim-session
Plug 'itchyny/lightline.vim' " Adds status line at bottom of the file
Plug 'ryanoasis/vim-devicons' " Adds file icons to NERDTree
Plug 'tpope/vim-dispatch' " Allows functions to run asyncrhonously from within VIM (:Dispatch)
Plug 'tpope/vim-repeat' " Allows plugins to repeat 
Plug 'tpope/vim-surround' " Use cs''[encloser] (that's a double-qutation mark) to modify encloser, ysiw[encloser] to add encloser
Plug 'tpope/vim-fugitive' " Git wrapper (:G followed by git commands)
Plug 'galooshi/vim-import-js' " Autoimport modules in javascript files (<leader>i or <leader>j)
Plug 'tpope/vim-unimpaired' " Key mappings
Plug 'junegunn/fzf', { 'do': './install --bin' } " Allows for fuzzy-finding of files from within vim.
Plug 'alvan/vim-closetag' " Auto-closing of HTML tags
Plug 'maxmellon/vim-jsx-pretty'  " Syntax highlighting for JSX
Plug 'junegunn/fzf.vim' " A required external dependency for fzf
Plug 'preservim/nerdcommenter' " Allows easy commenting (number<leader>c<space>)
Plug 'preservim/nerdtree' " Allows access to filesystem within VIM
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Add Icons to NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin' " Color folders based on Git Status (see config)
Plug 'pangloss/vim-javascript' " Indentation for javascript
Plug 'frazrepo/vim-rainbow' " Colors brackets differently
Plug 'tpope/vim-jdaddy' "Json text objects
Plug 'prettier/vim-prettier', { 'do': 'yarn install',  'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }  " Prettier for vim
Plug 'sbdchd/neoformat' " Run prettier on save
Plug 'haya14busa/incsearch.vim'
Plug 'dikiaap/minimalist' " Colorscheme...

call plug#end()




" ####################
" Visual Configuration 
" ####################

" Autoindent for next line
set expandtab " Use spaces instead of tabs
set tabstop=2  " Number of spaces that a tab counts for
set shiftwidth=2 " Controls autoindentation
set smartindent " Apply indentation of current line to next line
set autoindent " Apply indentation of current line to next line
set cursorline " Highlight current line
set wildmenu " Visual autocomplete for command menu

" Set colorscheme...
colorscheme minimalist

" Make comments italic
highlight Comment cterm=italic gui=italic


set foldmethod=syntax "syntax highlighting items specify folds
set foldcolumn=0 "defines 1 col at window left, to indicate folding
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened




" ####################
" Core Configuration + Mappings
" ####################

" Set leader to comma key
:let mapleader = ","

" Control searching
set ignorecase " Ignore case during search
set smartcase " ...Except if it includes a capital letter

" Easy movement within insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-h> <Left>

" Easy movement jumping in normal mode 
nnoremap <C-k> 10k 
nnoremap <C-j> 10j 

" Quick save
nnoremap H :w<cr>

"Prevent deletes from writing to registers..
nnoremap x "_x
nnoremap d "_d

"Map control-a to select all.
map <C-a> <esc>ggVG<CR> " Prettier for vim

" Allow backspace in insert mode
set backspace=indent,eol,start

:command! AllJs :args **/*.js

" ####################
" Plugin Configurations
" ####################

" ####################
" Conquer of Completion (CoC)
" ####################

" Edit snippets
:command! Snippets :e /Users/harrisoncramer/.config/coc/ultisnips/javascript.snippets

" Show documentation for variable
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Go to definition of variable.
nmap <silent> gd <Plug>(coc-definition)
" Open definition in a new split 
nmap gs :only<bar>vsplit<CR>gd
" Scroll through references within the same file
nmap <silent> gr <Plug>(coc-references)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ####################
" Save Session
" ####################

" Run command outside of vim
nnoremap :D :Dispatch! 

" ####################
" Save Session
" ####################

" Don't autosave session
:let g:session_autosave = 'no'

" Save and Restore sessions
nnoremap :SS :SaveSession<cr>
nnoremap :RS :OpenSession<cr>

" ####################
" Asynchronous Linting Engine (ALE) 
" ####################

" Customize ALE Signs (for ESLint)
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

"Run Eslint on save with Asynchronouse Lint Engine (ALE)
let g:ale_fixers = {
\  'javascript': ['eslint', 'prettier'],
\}
let g:ale_fix_on_save = 1

" Jump to next/previous error
nmap <silent> <Plug>GoToNextError :ALENext<cr> :call repeat#set("\<leader>E")<CR>
nmap <silent> <Plug>GoToPrevError :ALEPrevious<cr> :call repeat#set("\<leader>e")<CR>
" And map that to something easy to type...
nmap <leader>E <Plug>GoToNextError
nmap <leader>e <Plug>GoToPrevError

" ####################
" NERDTree
" ####################

" NERDTree doesn't show node_modules
let NERDTreeIgnore=['node_modules', '.git', '.DS_Store']

" NERDTREE based on Git Status (Xuyuanp/nerdtree-git-plugin)
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "○",
    \ "Staged"    : "✚",
    \ "Untracked" : "✗",
    \ "Renamed"   : "➜",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : 'i',
    \ "Unknown"   : "?"
    \ }

" Open NERDTree automatically on vim startup w/out arguments
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Autoclose NERDTree on open file
let NERDTreeQuitOnOpen = 1

" Prettier NERDTree setup
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:WebDevIconsTabAirLineAfterGlyphPadding = ' '

" Toggle NERDTree hidden files with f key
nmap <C-d> :NERDTreeToggle<CR>

" Color files in NerdTree
:hi NERDTreeFile guifg=#FF0000 ctermfg=white

" Let NERDTree show dot files
let NERDTreeShowHidden=1

" ####################
" Lightline
" ####################

" Turn on lightline
set laststatus=2

" Show full file path
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \ }
      \ }


" ####################
" Other Plugins
" ####################

" Remap git commands 
nnoremap :GA :G add .<cr>
nnoremap :GL :G log<cr>
nnoremap :GS :G status<cr>
nnoremap :GC :G commit -m 
nnoremap :GP :G push<cr>

" Turn on vim-rainbow plugin
let g:rainbow_active = 1

" Turn on vim-closetag for the following files
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"

" Remaps for incsearch plugin
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" CONFIGURE FIND SEARCH FOR FILES
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!{.git/*,*/node_modules/*,node_modules}" --color "always" '.shellescape(<q-args>), 1, <bang>0)

if !exists("g:syntax_on")
  syntax enable
endif
