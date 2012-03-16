setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal textwidth=80
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal smartindent
setlocal formatoptions=crql
setlocal number

"setlocal makeprg=ghc
"setlocal smartindent cinwords=if,else,where,try,except,finally,def,class 
autocmd BufWritePre *.hs %s/\s\+$//e
"
" general Haskell source settings
" (shared functions are in autoload/haskellmode.vim)
"
" (Claus Reinke, last modified: 28/04/2009)
"
" part of haskell plugins: http://projects.haskell.org/haskellmode-vim
" please send patches to <claus.reinke@talk21.com>

" try gf on import line, or ctrl-x ctrl-i, or [I, [i, ..
setlocal include=^import\\s*\\(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal suffixesadd=hs,lhs,hsc

