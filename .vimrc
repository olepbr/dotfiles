set nocompatible

"" Plugins

"" Install vim-plug if not present

if empty(glob('~/.vim/autoload/plug.vim'))
       	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"" Plugin List

call plug#begin('~/.vim/plugged')

"" Fugitive for git functionality
Plug 'tpope/vim-fugitive'

"" Commentary for commenting
Plug 'tpope/vim-commentary'

"" Polyglot for syntax highlighting
Plug 'sheerun/vim-polyglot'

"" YouCompleteMe for code completion
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
let g:ycm_autoclose_preview_window_after_completion = 1

"" Vimtex for LaTeX support
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

"" NERDTree, a system explorer
Plug 'preservim/nerdtree'

"" ALE for linting
Plug 'dense-analysis/ale'

"" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

"" Emmet-vim
Plug 'mattn/emmet-vim'

"" Vim Tmux Navigator
Plug 'christoomey/vim-tmux-navigator'

"" Goyo + limelight
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
let g:limelight_conceal_ctermfg = 'gray'

call plug#end()

syntax enable
set showmatch
set incsearch
set ignorecase
set hlsearch
set ruler
highlight CursorLine ctermbg=235
set foldmethod=marker
set spelllang=en_uk,nb_no

"" keybindings
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"" autocommands
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
			\ quit | endif
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
