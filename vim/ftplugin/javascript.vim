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

ab sop System.out.println

set makeprg=cat\ %\ \\\|\ rhino\ ~/bin/mylintrun.js\ %
set errorformat=%f:%l:%c:%m
