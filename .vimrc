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

call plug#end()

syntax enable
set showmatch
set incsearch
set ignorecase
set hlsearch
set ruler
set number relativenumber
set cursorline
highlight CursorLine ctermbg=235
set foldmethod=marker
