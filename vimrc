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

" General Settings
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


" Colorscheme Configuration
" Set default colorscheme
colorscheme gruvbox
set background=dark     " Use dark variant (light also available)

" List of colorschemes to cycle through
let g:colorscheme_list = ['gruvbox', 'solarized', 'onedark', 'nord']
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


" coc.nvim Configuration
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

" Go to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" vimspector Configuration
let g:vimspector_enable_mappings = 'HUMAN'  " Use human-readable key mappings
" Example: F5 to start debugging, F10 to step over, etc.

" NERDTree Configuration
nnoremap <C-n> :NERDTreeToggle<CR>  " Toggle NERDTree with Ctrl+n
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('t:NERDTreeBufName') && bufname('%') == t:NERDTreeBufName | quit | endif

" fzf.vim Configuration
nnoremap <C-p> :Files<CR>  " Open file finder with Ctrl+p

" vim-easymotion Configuration
map <Leader> <Plug>(easymotion-prefix)  " Use <Leader> (default \) for EasyMotion

" vim-gitgutter Configuration
" Enabled by default; customize signs if needed
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" vim-airline Configuration
let g:airline#extensions#tabline#enabled = 1  " Enable buffer tabline
