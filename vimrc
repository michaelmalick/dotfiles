"" Vim config file

set nocompatible
filetype plugin indent on
syntax on


"" base ----------------------------------------------------
set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set clipboard+=unnamedplus
set comments+=fb:•
set commentstring=
set complete-=i
set completeopt=menu,popup
set define=
set diffopt+=linematch:40
set display=lastline
set encoding=utf-8
set expandtab
set fileformats=unix,dos,mac
set fillchars=vert:│,fold:\ ,foldsep:│
set foldlevel=10
set formatoptions=tcqj
set hidden
set history=10000
set hlsearch
set ignorecase
set include=
set incsearch
set langnoremap
set laststatus=2
set list
set linebreak
set listchars=trail:·,tab:»·,nbsp:ϟ
set maxsearchcount=999
set mouse=nvi
set mousemodel=popup_setpos
set noerrorbells
set nojoinspaces
set nolangremap
set noshelltemp
set noshowmode
set nostartofline
set noswapfile
set nrformats=bin,hex
set path=.,,
set previewheight=20
set smartcase
set sessionoptions+=unix,slash sessionoptions-=options
set shortmess+=CF shortmess-=S
set shiftwidth=4
set sidescroll=1
set smarttab
set softtabstop=4
set spellcapcheck=''
set switchbuf=uselast
set tabpagemax=50
set tabstop=4
set tags=./tags;,tags
set textwidth=80
set ttimeout ttimeoutlen=50
set ttyfast
set undofile
set viminfo+=!
set viewoptions+=unix,slash viewoptions-=options
set virtualedit=block
set wildignorecase
set wildoptions=pum,tagfile

silent! packadd! comment
silent! packadd! editorconfig
silent! packadd! hlyank
silent! packadd! matchit


"" xdg -----------------------------------------------------
" match neovim stdpath()
"   config: ~/.config/vim        vimrc, after/, autoload/
"   data:   ~/.local/share/vim   plugins, spell files, netrw bookmarks
"   state:  ~/.local/state/vim   swap, backup, undo, views, viminfo
let s:xdg_data  = $XDG_DATA_HOME  .. '/vim'
let s:xdg_state = $XDG_STATE_HOME .. '/vim'

for s:dir in ['swap', 'backup', 'undo', 'view']
  call mkdir(s:xdg_state .. '/' .. s:dir, 'p', 0700)
endfor
call mkdir(s:xdg_data .. '/spell', 'p', 0700)

let &directory   = s:xdg_state .. '/swap//'
let &backupdir   = s:xdg_state .. '/backup//'
let &undodir     = s:xdg_state .. '/undo//'
let &viewdir     = s:xdg_state .. '/view'
let &viminfofile = s:xdg_state .. '/viminfo'
let &spellfile   = s:xdg_data  .. '/spell/en.utf-8.add'
let g:netrw_home = s:xdg_data


"" statusline ----------------------------------------------
set laststatus=2                               " Always show status line
set statusline=                                " Initialize empty status line
set statusline+=\ %n\                          " Buffer number
set statusline+=\ %f\                          " File name
set statusline+=%m                             " Modified flag
set statusline+=%r                             " Read only flag
set statusline+=%h                             " Help flag
set statusline+=%w                             " Preview window flag
set statusline+=%=                             " Switch to right side
set statusline +=\ %{&ff}\                     " File format
let &stl .= ' %{&fenc !=# "" ? &fenc : &enc} ' " File encoding
set statusline+=\ %3l:%-2c                     " Current line:column
set statusline+=\ \ %L                         " Total lines
set statusline+=\ \ %P\                        " Percentage of file showing


"" mappings ------------------------------------------------
let mapleader = ' '
let maplocalleader = '\'
nnoremap <silent> gh :nohlsearch<CR>
nnoremap <silent> <leader>0 :execute 'edit' $MYVIMRC<CR>
