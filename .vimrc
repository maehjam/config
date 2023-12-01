" Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'airblade/vim-gitgutter'
call plug#end()

syntax on
filetype indent plugin on

" General look and behaviour
syntax on
set bg=light
colorscheme slate
highlight Normal ctermbg=NONE
set tabstop=4 expandtab shiftwidth=4
set backspace=2
let g:indentLine_color_term=235
let g:indentLine_char='⎸'
set colorcolumn=81
hi ColorColumn ctermbg=234
highlight Pmenu ctermbg=238 gui=bold
hi conceal ctermfg=234
set nu
set rnu
set laststatus=2
set ruler

" Netrw config
let g:netrw_banner = 0
let g:netrw_winsize = 15

" Gitgutter config -------------------------------------------------------------
" Jump with `[c` and `]c`
set updatetime=200
set signcolumn=auto

" Erlang-ls config -------------------------------------------------------------
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" set statusline=%n\ %<%f\ %h%m%r%w%=%-14.(%l,%c%V%) \ %P \ %{coc#status()} 
set statusline=%n:\ %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P\ %{coc#status()}

nmap <silent> [l <Plug>(coc-diagnostic-prev)
nmap <silent> ]l <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> ä <Plug>(coc-definition)
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

" ------------------------------------------------------------------------------

" MarkdownPreview config -------------------------------------------------------
"function OpenMarkdownPreview (url)
"    execute "silent ! open -n " . a:url
"endfunction
"let g:mkdp_browserfunc = 'OpenMarkdownPreview'
" ------------------------------------------------------------------------------
" set spellfile=$HOME/.vim/spell/en.utf-8.add
" set tags=tags;./tags;
" let g:erlang_tags_ignore=['./_build/*','./_checkouts/*/_build/*']

" File name completion behaviour
set path+=**
set wildmenu
" set wildmode=longest,list

" autocomplete
set completeopt+=menuone
set completeopt-=preview

" snipples
noremap ümod :read $HOME/.vim/erlang-templates/module.erl<CR>kdd3j2w"%pldF.bdT(G
noremap üser :read $HOME/.vim/erlang-templates/gen_server.erl<CR>kdd2w"%pldF.bdT(G
noremap üsta :read $HOME/.vim/erlang-templates/gen_statem.erl<CR>kdd2w"%pldF.bdT(G
noremap üsup :read $HOME/.vim/erlang-templates/supervisor.erl<CR>kdd2w"%pldF.bdT(G
noremap ütes :read $HOME/.vim/erlang-templates/test_SUITE.erl<CR>kdd2w"%pldF.bdT(G
noremap üws :read $HOME/.vim/erlang-templates/ws_handler.erl<CR>kdd2w"%pldF.bdT(G45gg9w"%pldF_bdT(G61gg2w"%pldFwbdT G
noremap ükj :read $HOME/.vim/erlang-templates/jsonrpc_kraft.erl<CR>kdd3j2w"%pldF.bdT(G
noremap ücas icase<space>of<CR>end<Esc>kkea<space>
noremap üio iio:format("",[]),<Esc>F"i
noremap üfb :read $HOME/.vim/st-templates/fb.st<CR>kddea <Esc>"%pF.D37gg$h"%pF.d2wbdf_gUeea(IN1, IN2)<Esc>

" Remap uncomfortable keys
inoremap üü <Esc>
vnoremap üü <Esc>
nnoremap üü <Esc>:w<CR>
" nnoremap ä <gd>
inoremap üo <C-o>
vnoremap üo <C-o>
nnoremap üo <C-o>
inoremap ün <C-n>
inoremap üw <C-w>
vnoremap üw <C-w>
nnoremap üw <C-w>

" Copy Paste
set clipboard=unnamed

" Mouse
set mouse=nvi

" Cursor
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[1 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)
