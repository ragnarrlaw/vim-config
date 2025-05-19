" Ensure Vim 9.0 compatibility
if v:version < 900
  echoerr "This configuration requires Vim 9.0 or higher"
  finish
endif

" Install vim-plug if not present
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify directory for plugins
call plug#begin('~/.vim/plugged')

" LSP and Autocompletions
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Debugging
Plug 'puremourning/vimspector'

" Git Integration
Plug 'airblade/vim-gitgutter'

" File Tree Navigation
Plug 'preservim/nerdtree'

" Status Bar
Plug 'vim-airline/vim-airline'

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Easy Navigation
Plug 'easymotion/vim-easymotion'

" Syntax Highlighting for Multiple Languages
Plug 'sheerun/vim-polyglot'

" Colorschemes
Plug 'rafi/awesome-vim-colorschemes'

call plug#end()

" General Settings ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
let g:mapleader = "\<Space>"
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set tabstop=4           " 4 spaces per tab
set shiftwidth=4        " 4 spaces for indentation
set expandtab           " Convert tabs to spaces
set autoindent          " Auto-indent new lines
set encoding=utf-8      " Use UTF-8 encoding
set signcolumn=yes      " Always show sign column for diagnostics
set updatetime=300      " Faster updates for better UX
set mouse=a             " Enable mouse support
set termguicolors       " Enable true color support for colorschemes

" General keymap settings +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" I hate escape more than anything else
inoremap jk <Esc>
inoremap kj <Esc>

" Colorscheme configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" Set default colorscheme
colorscheme gruvbox
set background=dark     " Use dark variant (light also available)

" List of colorschemes to cycle through
let g:colorscheme_list = ['gruvbox', 'onedark', 'nord']
let g:colorscheme_index = 0

" Function to cycle through colorschemes
function! CycleColorscheme()
  let g:colorscheme_index = (g:colorscheme_index + 1) % len(g:colorscheme_list)
  let l:scheme = g:colorscheme_list[g:colorscheme_index]
  execute 'colorscheme' l:scheme
  echo 'Colorscheme:' l:scheme
endfunction

" Map <Leader>c to cycle colorschemes
nnoremap <Leader>c :call CycleColorscheme()<CR>

" coc.nvim configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" Set custom coc.nvim config location - make sure this is the correct location
let g:coc_config_home = '~/playground/vim'
" Use Tab for completion navigation
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Function to check backspace
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" vimspector configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
let g:vimspector_enable_mappings = 'HUMAN'  " Use human-readable key mappings
" Example: F5 to start debugging, F10 to step over, etc.

" NERDTree configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
nnoremap <C-n> :NERDTreeToggle<CR>  " Toggle NERDTree with Ctrl+n
let g:NERDTreeShowHidden=1
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('t:NERDTreeBufName') && bufname('%') == t:NERDTreeBufName | quit | endif

" FZF configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" fzf.vim Configuration
nnoremap <C-p> :Files<CR>  " Open file finder with Ctrl+p

" vim easymotion configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
map <Leader> <Plug>(easymotion-prefix)  " Use <Leader> (default \) for EasyMotion

" vim-gitgutter configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" Enabled by default; customize signs if needed
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" vim-ariline configurations +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
let g:airline#extensions#tabline#enabled = 1  " Enable buffer tabline
