autocmd BufWritePre *.sql exe "normal mk" | %s/.*/\U&/e | nohlsearch | exe "normal g`k"
