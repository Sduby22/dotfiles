" Author: osennyaya <supersduby@gmail.com>
" Description: Plugins, Options, Import other configs
" File: init.vim

filetype plugin indent on

set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set sts=-1
set smarttab
set smartcase ignorecase
set autoindent
set nu rnu
set pumheight=10

set completeopt=menuone,noselect

syntax on

" Install vim-plug if not exist
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Shared plugins
Plug 'airblade/vim-rooter'
Plug 'farmergreg/vim-lastplace'
Plug 'vim-scripts/gitignore'
Plug 'tpope/vim-sleuth'

Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'preservim/nerdcommenter'
Plug 'junegunn/vim-easy-align'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

if !exists('g:vscode')
" Vscode disabled plugins

Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'rktjmp/lush.nvim'
Plug 'npxbr/gruvbox.nvim'
Plug 'Th3Whit3Wolf/one-nvim'

Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'wakatime/vim-wakatime'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/nvim-compe'
endif

call plug#end()

let g:go_fmt_autosave = 0

set path+=**                                                                    
set wildignore+=**/node_modules/**
set wildignore+=**/.git/**
set clipboard+=unnamedplus

let mapleader=" "
nmap Q <Nop> 
imap <C-c> <esc>
set mouse+=a
set noerrorbells visualbell t_vb=

source ~/.config/nvim/firenvim.vim
source ~/.config/nvim/indent.vim
source ~/.config/nvim/leaderf.vim

if !exists('g:vscode')

  colorscheme gruvbox
  set termguicolors

  let g:UltiSnipsExpandTrigger="<C-x>"
  let g:UltiSnipsJumpForwardTrigger="<C-j>"
  let g:UltiSnipsJumpBackwardTrigger="<C-k>"

  inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
  lua require('lua-config')

else 
  lua requite('vscode-config')
endif

" Yank highlighting
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
augroup END
