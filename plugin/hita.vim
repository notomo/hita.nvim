if exists('g:loaded_hita')
    finish
endif
let g:loaded_hita = 1

command! -nargs=* Hita lua require("hita/command").main(<f-args>)

highlight default link HitaTarget ErrorMsg
highlight default link HitaTwoTargetFirst WarningMsg
highlight default link HitaTwoTargetSecond WarningMsg
