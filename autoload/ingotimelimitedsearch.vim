" ingotimelimitedsearch.vim: Custom functions for time-limited searching.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	17-Oct-2012	file creation

if v:version < 702 || ! has('reltime')
function! ingotimelimitedsearch#GetSearchArguments( timeout )
    " Limit searching to a maximum number of lines after the cursor.
    " Assume that 10000 lines can be searched per second; this depends greatly
    " on the CPU, regexp, and line length.
    return [(a:timeout == 0 ? 0 : line('.') + a:timeout * 10)]
endfunction
else
function! ingotimelimitedsearch#GetSearchArguments( timeout )
    return [0, a:timeout]
endfunction
endif

function! ingotimelimitedsearch#search( pattern, flags, ... )
    let l:timeout = (a:0 ? a:1 : 100)
    return call('search', [a:pattern, a:flags] + ingotimelimitedsearch#GetSearchArguments(l:timeout))
endfunction
function! ingotimelimitedsearch#IsBufferContains( pattern, ... )
    return call('ingotimelimitedsearch#search', [a:pattern, 'cnw'] + a:000)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
