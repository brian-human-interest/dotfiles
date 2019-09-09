filetype plugin indent on
syntax enable

" helps fix syntax highlighting on large files when hopping around
syntax sync minlines=10000
set redrawtime=10000
syntax sync fromstart

set nocompatible

" Install vim plugins
if filereadable(expand('~/.vim/vimrc.bundles'))
  source ~/.vim/vimrc.bundles
endif

" colorscheme
set background=dark
set termguicolors
let g:materialmonokai_italic=1
colorscheme material-monokai

" fuzzy finder settings
" set path+=**
" set wildmenu

" set foldmethod=indent
set helpheight=999
set ruler
set hlsearch
set wrapscan
" set mouse=h " for neovim
set number
set ignorecase
set smartcase

" stops annoying time delay
set timeoutlen=1000 ttimeoutlen=0

" keep cursor in the middle of the screen
" set scrolloff=999
" set relativenumber

set cursorline
hi CursorLine cterm=NONE ctermbg=darkgray

" tab logic
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" if has('nvim')
"   tnoremap <Esc> <C-\><C-n>
" endif

autocmd FileType haskell setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType python setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead *.bash set filetype=sh

" runtime macros/matchit.vim

" automatically save sessions
let g:startify_session_persistence = 1

" use these to auto-open folds
" autocmd BufEnter ?* silent! %foldopen!
" autocmd BufEnter ?* silent! %foldopen!

" Tweaks for browsing
" thanks to https://github.com/mcantor/no_plugins/blob/0a313c353899d3d4e51b754b15027c4452120f79/no_plugins.vim#L120-L133
" let g:netrw_banner=0        " disable annoying banner
" let g:netrw_browse_split=4  " open in prior window
" let g:netrw_altv=1          " open splits to the right
" let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" mappings
" lets you use j/k to navigate wrapped lines in a more natural way
noremap j gj
noremap k gk

noremap gj j
noremap gk k

" easier escape sequence
nnoremap ! :!

vnoremap 0 ^
nnoremap 0 ^

vnoremap ^ 0
nnoremap ^ 0

" better search
" nnoremap / q/i
" nnoremap q/ /
" 
" vnoremap / q/i
" vnoremap q/ /

" better search
" nnoremap : q:i
" nnoremap q: :
" 
" vnoremap : q:i
" vnoremap q: :

" quick save
" nnoremap <C-s> :update<Enter>
" vnoremap <C-s> :update<Enter>

map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
vnoremap <silent> <C-t> :NERDTreeToggle<CR>

" comments
vmap <silent> <LocalLeader>cc gck<CR>
nmap <silent> <LocalLeader>cc gcck<CR>
vmap <silent> <C-/> gck<CR>
nmap <silent> <C-/> gcck<CR>

" fuzzy find
map <silent> <leader>ff :FZF<CR>
map <silent> <C-f> :FZF<CR>

" copy current filepath into vim clipboard
nmap cp :let @" = expand("%")<cr>

" basic emacs motions in insert mode
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A

" if file is larger than 10mb
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
    autocmd BufReadPre * call HandleLargeFiles()
augroup END

" shortcut to execute file
" noremap <Leader>e :call Execute()<CR>
" fun! Execute()
"   :execute 'update'
"   :execute '! ./%'
" endfun

set tabline=%!MyTabLine()
set showtabline=2

" helpful console.log shortcut in js/ts land
autocmd FileType javascript inoremap <C-l> console.log();<Left><Left>
autocmd FileType typescript inoremap <C-l> console.log();<Left><Left>

" could be interesting
" Ctrl j/k to navigate horizontal splits
" map <C-J> <C-W>j<C-W>_
" map <C-K> <C-W>k<C-W>_
" set wmh=0
" Ctrl h/l to navigate vertical splits
" map <C-H> <C-W>h<C-W><bar>
" map <C-L> <C-W>l<C-W><bar>
" set wmw=0

" Function Definitions
function! HandleLargeFiles()
    let f=getfsize(expand("<afile>"))
    if f > g:LargeFile || f == -2
        call PromptOpenLargeFile()
    endif
endfunction

function! PromptOpenLargeFile()
    let choice = confirm("The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB - Do you want to open it?", "&Yes\n&No", 2)
    if choice == 0 || choice == 2
        :q
    endif
endfunction

" from :help setting-tabline
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for viewing)
    let s .= '[' . (i + 1) . ']'

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= '%{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  return s
endfunction

" with help from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let file = bufname(bufnr)
  let buftype = getbufvar(bufnr, 'buftype')

  if buftype == 'nofile'
    if file =~ '\/.'
      let file = substitute(file, '.*\/\ze.', '', '')
    endif
  else
    let file = fnamemodify(file, ':p:t')
  endif
  if file == ''
    let file = '[No Name]'
  endif
  return file
endfunction

" Ale
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap gh :ALEHover<CR>
highlight clear ALEError
let g:ale_linters = {
      \   'javascript': ['eslint', 'tsserver'],
      \   'typescript': ['tslint', 'tsserver']
      \}
let g:ale_fixers = {
      \'javascript': ['prettier', 'eslint', 'remove_trailing_lines', 'trim_whitespace'],
      \'typescript': ['prettier','tslint', 'remove_trailing_lines', 'trim_whitespace']
      \}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_lint_delay = 0 " will this be fast?
nmap <silent> <C-h> <Plug>(ale_previous_wrap)
nmap <silent> <C-l> <Plug>(ale_next_wrap)

" fzf
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_tags_command = 'ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }


" nerdtree
let NERDTreeIgnore=['\.pyc$', '\.o$', '\.class$', '\.lo$', 'tmp']
let NERDTreeHijackNetrw = 0
let g:netrw_banner = 0

command! NF :NERDTreeFind
command! Nf :NERDTreeFind
