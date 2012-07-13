" ConflictDetection.vim: Detect and highlight SCM conflict markers.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	12-Mar-2012	file creation

function! ConflictDetection#Highlight()
    syntax region conflictOurs   matchgroup=conflictOursMarker start="^<\{7}<\@!.*$"   end="^\([=|]\)\{7}\1\@!"me=s-1 keepend containedin=TOP
    syntax region conflictBase   matchgroup=conflictBaseMarker start="^|\{7}|\@!.*$"   end="^=\{7}=\@!"me=s-1         keepend containedin=TOP
    syntax region conflictTheirs start="^=\{7}=\@!.*$" matchgroup=conflictTheirsMarker end="^>\{7}>\@!.*$"            keepend containedin=TOP contains=conflictSeparatorMarkerSymbol

    syntax match conflictOursMarkerSymbol       "^<\{7}"        contained
    syntax match conflictBaseMarkerSymbol       "^|\{7}"        contained
    syntax match conflictSeparatorMarkerSymbol  "^=\{7}"        contained
    syntax match conflictTheirsMarkerSymbol     "^>\{7}"        contained
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
