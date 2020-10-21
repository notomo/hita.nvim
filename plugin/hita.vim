if exists('g:loaded_hita')
    finish
endif
let g:loaded_hita = 1

if get(g:, 'hita_debug', v:false)
    command! -nargs=* Hita lua require("hita/lib/cleanup")(); require("hita/command").main(<f-args>)
else
    command! -nargs=* Hita lua require("hita/command").main(<f-args>)
endif

highlight default link HitaTarget ErrorMsg
highlight default link HitaTwoTargetFirst WarningMsg
highlight default link HitaTwoTargetSecond WarningMsg
