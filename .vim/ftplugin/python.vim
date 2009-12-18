setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=80
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal smartindent
setlocal formatoptions=crql
setlocal number
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class 
autocmd BufWritePre *.py %s/\s\+$//e

" Abreviation to insert IPython embeded shell
iab IP (__import__("IPython").Shell.IPShellEmbed())()
