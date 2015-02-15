" Useful links for vim configuration
" http://learnvimscriptthehardway.stevelosh.com/
" http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
" http://vim.wikia.com/wiki/Copy,_cut_and_paste

set nocompatible

set encoding=utf-8
set binary

set ruler		" line and column number of the cursor position
"set nowrap		" don't wrap lines
set shiftround		" use multiple of shiftwidth when indenting with '<' and '>'
set showmatch		" show matching parenthesis
set showcmd		" show number of selected lines in visual mode

" search settings
set hlsearch		" highlight search terms
set incsearch		" show search matches as you type
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase, case-sensitive otherwise

" ignore some file extensions when completing names by pressing Tab
set wildignore=*.swp,*~,*.bak,*.pyc,*.jpg,*.png,*.xpm,*.gif
set nobackup		" do not create backup file ~

" increase buffer size
set viminfo='100,<1000,s20,h

set pastetoggle=<F2>

filetype plugin indent on
syntax on

highlight ExtraWhitespace ctermbg=red guibg=red
highlight Search ctermbg=LightBlue guibg=LightBlue

match ExtraWhitespace /\s\+$/

" Press F3 to toggle number on/off, and show current value.
noremap <F3> :set number! number?<CR>

" Press F4 to toggle relativenumber on/off, and show current value.
noremap <F4> :set relativenumber! relativenumber?<CR>

" Press F5 to toggle highlighting on/off, and show current value.
noremap <F5> :set hlsearch! hlsearch?<CR>

nnoremap ; :

" Remember last position in file
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Turn off auto adding comments on next line
"set fo=tcq
autocmd FileType * setlocal formatoptions-=c formatoptions-=r
