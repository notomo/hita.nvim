if exists('g:loaded_hita')
    finish
endif
let g:loaded_hita = 1

if get(g:, 'hita_debug', v:false)
    let s:path = expand('<sfile>:h:h') .. '/lua/'
    execute printf('command! -nargs=* Hita lua require("hita/cleanup")("%s"); require "hita/command".main(<f-args>)', s:path)
else
    command! -nargs=* Hita lua require 'hita/command'.main(<f-args>)
endif

highlight default link HitaTarget ErrorMsg
highlight default link HitaBackground Comment
