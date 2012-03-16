set nocompatible

syntax on

set tabstop=8
set shiftwidth=8
set cmdheight=2
set incsearch
set hlsearch
"set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
set mouse=a

set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2

" Enable loading of plugins and indentation for specific file types
" (from my ~/.vim directory)
filetype plugin indent on

" COMPLETION
" Add dictionnaries for completion. In ubuntu, to install the french
" dictionary, do sudo apt-get install wfrench
" set dictionary+=/usr/share/dict/french,/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english
set completeopt+=longest
" When completion menu is visible, I want to select an entry with Enter
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>" 
" When I do CTRL-N to do completion, select the first item
inoremap <expr> <c-n> pumvisible() ? "\<down>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Command line completion with the nice wildmenu
set wildmenu
set wildmode=list:longest,full

" Function to toggle spell checking
let g:FredSpellChecking=0
function! ToggleSpellChecking()
	if g:FredSpellChecking == 0
		set spell
		let g:FredSpellChecking=1
		echo "Spell checking on"

	elseif g:FredSpellChecking == 1
		set spell!
		let g:FredSpellChecking=0
		echo "Spell checking off"
	endif
endfunction

" Toggle spell checking
map <F7> <ESC>:call ToggleSpellChecking()<CR>

" Taglist plugin (nice!)
nmap <F8> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1

" Make
command -nargs=* Make w | copen 3 | make <args> | cwindow 3
command SaveAndMake w | make
" nmap ,m :SaveAndMake<CR>
nmap ,m :Make<CR>

nmap ,f :FufFile<CR>

" Rebuild tags for C files
function! RebuildCTags()
python << EOF
import os
#os.system('find -L -name "*.[ch]" | xargs cscope -b')
# Build a ctags database compatible with omnicppcomplete
os.system('ctags -R -I --c++-kinds=+p --fields=+iaS --extra=+q')
EOF
"	silent! cscope kill -1
"	silent! cscope add cscope.out
endfunction

" Rebuild tags for Python files
function! RebuildPythonTags()
python << EOF
# Build a ctags database 
__import__("os").system('ctags --recurse=yes *')
EOF
endfunction

" Options for python.vim syntax file from vim.org. It is an improvement from
" the one that comes with vim
let python_highlight_all = 1
let python_slow_sync = 1

" Set F11 to toggle paste mode. This prevents and "indenting staircase" when
" pasting text.
set pastetoggle=<F11>

augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

augroup END

" Disable swap file
set nobackup
set nowritebackup
set noswapfile

" Haskelmode stuff

" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

" configure browser for haskell_doc.vim
let g:haddock_browser = "firefox"

function! UPDATE_TAGS()
  echo "UPDATE_TAGS"
  let _f_ = expand("%:p")
  let _cmd_ = '"ctags -a -f /dvr/tags --c++-kinds=+p --fields=+iaS --extra=+q " ' . '"' . _f_ . '"'
  let _resp = system(_cmd_)
  unlet _cmd_
  unlet _f_
  unlet _resp
endfunction
"autocmd BufWrite *.C,*.cpp,*.h,*.c call UPDATE_TAGS()

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

let g:inkpot_black_background = 1

hi CursorLine ctermbg=235
hi CursorColumn ctermbg=235

set background=dark
