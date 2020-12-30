" Plugins
execute pathogen#infect()
syntax on
filetype indent plugin on

" General look and behaviour
colorscheme slate
syntax on
set tabstop=4 expandtab shiftwidth=4
set backspace=2
let g:indentLine_color_term=235
let g:indentLine_char='⎸'
set colorcolumn=81
hi ColorColumn ctermbg=234
hi conceal ctermfg=234
set nu
set rnu
set laststatus=2
set ruler

" Netrw config
let g:netrw_banner = 0
let g:netrw_winsize = 15

" set spellfile=$HOME/.vim/spell/en.utf-8.add
set tags=tags;./tags;
let g:erlang_tags_ignore=['./_build/*','./_checkouts/*/_build/*']

" File name completion behaviour
set path+=**
set wildmenu
" set wildmode=longest,list

" autocomplete
set completeopt+=menuone
set completeopt-=preview

" snipples
noremap ümod :read $HOME/.vim/erlang-templates/module.erl<CR>kdd2w"%pldF.bdT(G
noremap üser :read $HOME/.vim/erlang-templates/gen_server.erl<CR>kdd2w"%pldF.bdT(G
noremap üsta :read $HOME/.vim/erlang-templates/gen_statem.erl<CR>kdd2w"%pldF.bdT(G
noremap üsup :read $HOME/.vim/erlang-templates/supervisor.erl<CR>kdd2w"%pldF.bdT(G
noremap ücas icase<space>of<CR>end<Esc>kkea<space>
noremap üio iio:format("",[]),<Esc>F"i
noremap üfb :read $HOME/.vim/st-templates/fb.st<CR>kddea <Esc>"%pF.D37gg$h"%pF.d2wbdf_gUeea(IN1, IN2)<Esc>

" Remap uncomfortable keys
inoremap üü <Esc>
vnoremap üü <Esc>
nnoremap üü <Esc>:w<CR>
nnoremap ä <C-]>
nnoremap Ä <C-t>

" Copy Paste
set clipboard=unnamed

" Mouse
set mouse=a

" Cursor
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[1 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)
