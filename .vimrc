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

"" Vimtex for LaTeX support
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

call plug#end()

syntax enable
set showmatch
set incsearch
set ignorecase
set hlsearch
set ruler
set cursorline
highlight CursorLine ctermbg=235
set foldmethod=marker
