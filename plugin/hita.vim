if exists('g:loaded_hita')
    finish
endif
let g:loaded_hita = 1

if get(g:, 'hita_debug', v:false)
    command! -nargs=* Hita lua require("hita/cleanup")("hita"); require("hita/command").main(<f-args>)
else
    command! -nargs=* Hita lua require("hita/command").main(<f-args>)
endif

highlight default link HitaTarget ErrorMsg
highlight default link HitaBackground Comment
