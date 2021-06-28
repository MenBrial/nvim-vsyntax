if exists('g:vsyntax')
	finish
endif
let g:vsyntax = 1

:command VSyntaxToggle :lua require('nvim-vsyntax').toggle()
:command VSyntaxEnable :lua require('nvim-vsyntax').enable()
:command VSyntaxDisable :lua require('nvim-vsyntax').disable()
