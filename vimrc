"""""""""""""""""""""""""
" Basic features
"""""""""""""""""""""""""
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Display options
syntax on
set cursorline
set number
set list!                       " Display unprintable characters
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«
if $TERM =~ '256color'
  set t_Co=256
elseif $TERM =~ '^xterm$'
  set t_Co=256
endif

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Misc
set modeline                    " enable modelines
set hidden                      " Don't abandon buffers moved to the background
set wildmenu                    " Enhanced completion hints in command line
set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set complete=.,w,b,u,U,t,i,d    " Do lots of scanning on tab completion
set updatecount=100             " Write swap file to disk every 100 chars
set directory=~/.vim/swap       " Directory to use for the swap file
set diffopt=filler,iwhite       " In diff mode, ignore whitespace changes and align unchanged lines

" Indentation and tabbing
set autoindent smartindent
set smarttab                    " Make <tab> and <backspace> smarter
set tabstop=3
set shiftwidth=3                " Indents of 8 spaces

" viminfo: remember certain things when we exit
" (http://vimdoc.sourceforge.net/htmldoc/usr_21.html)
"   %    : saves and restores the buffer list
"   '100 : marks will be remembered for up to 30 previously edited files
"   /100 : save 100 lines from search history
"   h    : disable hlsearch on start
"   "500 : save up to 500 lines for each register
"   :100 : up to 100 lines of command-line history will be remembered
"   n... : where to save the viminfo files
set viminfo=%100,'100,/100,h,\"500,:100,n~/.vim/viminfo

" Undo
set undolevels=10000
if has("persistent_undo")
  set undodir=~/.vim/undo       " Allow undoes to persist even after a file is closed
  set undofile
endif
nnoremap <C-u> :GundoToggle<CR>

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

" to_html settings
let html_number_lines = 0
let html_ignore_folding = 1
let html_use_css = 1
"let html_no_pre = 0
"let use_xhtml = 1
let xml_use_xhtml = 1

set selectmode+=mouse
set mouse=a

set clipboard=unnamed

"""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""
nnoremap <C-g> :NERDTreeToggle<cr>
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$' ]
let NERDTreeHighlightCursorline=1
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1

let g:SuperTabMappingForward = '<nul>'
let g:SuperTabMappingBackward = '<s-nul>'

nnoremap <C-y> :YRShow<cr>
let g:yankring_history_dir = '$HOME/.vim'
let g:yankring_manual_clipboard_check = 0

let g:quickfixsigns_classes=['qfl', 'vcsdiff', 'breakpoints']

let g:syntastic_enable_signs=1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['c', 'scss'] }

let g:Powerline_symbols = 'unicode'
set laststatus=2

let g:ctrlp_map = '<c-e>'
let g:ctrlp_custom_ignore = '/\.\|\.o\|\.so'

noremap <Leader>t= :Tabularize /=<CR>
noremap <Leader>t: :Tabularize /^[^:]*:\zs/l0l1<CR>
noremap <Leader>t> :Tabularize /=><CR>
noremap <Leader>t, :Tabularize /,\zs/l0l1<CR>

"""""""""""""""""""""""""
" Custom functions
"""""""""""""""""""""""""
:command -bar -nargs=1 OpenURL :!firefox <args>

nmap fc :call CleanClose(1)<cr>
nmap fq :call CleanClose(0)<cr>
function! CleanClose(tosave)
  if (a:tosave == 1)
      w!
  endif
  let todelbufNr = bufnr("%")
  let newbufNr = bufnr("#")
  if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
      exe "b".newbufNr
  else
      bnext
  endif
  if (bufnr("%") == todelbufNr)
      new
  endif
  exe "bd!".todelbufNr
endfunction

" When opening a file, always jump to the last cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \     exe "normal g'\"" |
    \ endif |

" Screen settings
let g:ScreenImpl = 'Tmux'
let g:ScreenShellTmuxInitArgs = '-2'
let g:ScreenShellInitialFocus = 'shell'
let g:ScreenShellQuitOnVimExit = 0
map <F5> :ScreenShellVertical<CR>
command -nargs=? -complete=shellcmd W  :w | :call ScreenShellSend("load '".@%."';")

" Always edit file, even when swap file is found
set shortmess+=A

" Toggle paste mode while in insert mode with F12
set pastetoggle=<F12>
