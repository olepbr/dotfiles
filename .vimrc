set nocompatible
let mapleader = "\<Space>"
let maplocalleader = "\\"

" =============================================================================
" # plugins
" =============================================================================

" install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
       	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" vim enhancements
Plug 'ciaranm/securemodelines'
Plug 'christoomey/vim-tmux-navigator'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
let g:limelight_conceal_ctermfg = 'gray'

" Commentary for commenting
Plug 'tpope/vim-commentary'

" syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jparise/vim-graphql'

" warm 'n' fuzzy
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" semantic language support
if has('nvim')
      Plug 'Olical/conjure'
      Plug 'hrsh7th/cmp-buffer'
      Plug 'hrsh7th/cmp-cmdline'
      Plug 'hrsh7th/cmp-nvim-lsp'
      Plug 'hrsh7th/cmp-path'
      Plug 'hrsh7th/cmp-vsnip'
      Plug 'hrsh7th/nvim-cmp'
      Plug 'neovim/nvim-lspconfig'
      Plug 'nvim-lua/plenary.nvim'
      Plug 'ray-x/lsp_signature.nvim'
endif

" snippet engine
Plug 'hrsh7th/vim-vsnip'

call plug#end()

set foldmethod=marker
set spelllang=en_uk,nb_no

" lightline
let g:lightline = {
			\ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
set shortmess+=c

" =============================================================================
" # editor settings
" =============================================================================

set showmatch
set noshowmode
set hidden
set signcolumn=yes
set expandtab
set tabstop=4
set shiftwidth=4

" undo history
set undodir=~/.vimdid
set undofile

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" =============================================================================
" # gui settings
" =============================================================================

set guioptions-=T " Remove toolbar
highlight clear SignColumn

" sane splits
set splitright
set splitbelow

" search
set incsearch
set ignorecase
set smartcase

" hidden chars
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" =============================================================================
" # keybindings
" =============================================================================

" nerdtree
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" quicksave
nmap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" unhighlight
nmap <leader>h :nohlsearch<cr>

" clip-clip
noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

" open shit
map <C-p> :Files<CR>
nmap <leader>z :Buffers<CR>

" jump to start/end of line with le row du maison
map H ^
map L $

" <leader>s for rg search
noremap <leader>s :Rg<CR>
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

" Open new file adjacent to current file
nnoremap <leader>o :e <C-R>=expand("%:p:h") . "/" <CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" =============================================================================
" # autocommands
" =============================================================================

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
			\ quit | endif
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
