" ConflictDetection.vim: Detect and highlight SCM conflict markers.
"
" DEPENDENCIES:
"   - ConflictDetection.vim autoload script
"   - ingotimelimitedsearch.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.01.002	17-Oct-2012	Delegate search to
"				ingotimelimitedsearch#IsBufferContains() to
"				avoid long search delays on very large files.
"   1.00.001	12-Mar-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ConflictDetection') || (v:version < 700)
    finish
endif
let g:loaded_ConflictDetection = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:ConflictDetection_AutoDetectEvents')
    let g:ConflictDetection_AutoDetectEvents = 'BufReadPost,BufWritePre'
endif
if ! exists('g:ConflictDetection_WarnEvents')
    let g:ConflictDetection_WarnEvents = 'BufReadPost,BufWritePost'
endif


"- functions -------------------------------------------------------------------

function! s:ConflictCheck()
    let b:conflicted = !! ingotimelimitedsearch#IsBufferContains('^\([<=>|]\)\{7}\1\@!')
endfunction
function! s:ConflictWarn()
    if ! exists('b:conflicted')
	call s:ConflictCheck()
    endif

    if b:conflicted
	let v:warningmsg = 'Conflict markers found'
	echohl WarningMsg
	echomsg v:warningmsg
	echohl None
    endif
endfunction
function! s:ConflictHighlight()
    if ! exists('b:conflicted')
	call s:ConflictCheck()
    endif

    if b:conflicted
	call ConflictDetection#Highlight()
    endif
endfunction


"- autocmds --------------------------------------------------------------------

augroup ConflictDetection
    autocmd!
    if ! empty(g:ConflictDetection_AutoDetectEvents)
	execute 'autocmd' g:ConflictDetection_AutoDetectEvents '* call <SID>ConflictCheck()'
    endif
    if ! empty(g:ConflictDetection_WarnEvents)
	execute 'autocmd' g:ConflictDetection_WarnEvents '* call <SID>ConflictWarn()'
    endif

    autocmd BufReadPost,FileType * call <SID>ConflictHighlight()
augroup END


"- highlight groups ------------------------------------------------------------

highlight def link conflictOurs                     DiffAdd
highlight def link conflictBase                     DiffChange
highlight def link conflictTheirs                   DiffText
highlight def link conflictSeparatorMarkerSymbol    NonText

highlight def conflictSeparatorMarker   ctermfg=Grey guifg=Grey
function! s:HighlightMarkerDefaultsLikeDiffHighlights()
    execute 'highlight def conflictOursMarker   ctermfg=' . synIDattr(synIDtrans(hlID('DiffAdd')),    'bg', 'cterm') . ' guifg=' . synIDattr(synIDtrans(hlID('DiffAdd')),    'bg', 'gui')
    execute 'highlight def conflictBaseMarker   ctermfg=' . synIDattr(synIDtrans(hlID('DiffChange')), 'bg', 'cterm') . ' guifg=' . synIDattr(synIDtrans(hlID('DiffChange')), 'bg', 'gui')
    execute 'highlight def conflictTheirsMarker ctermfg=' . synIDattr(synIDtrans(hlID('DiffText')),   'bg', 'cterm') . ' guifg=' . synIDattr(synIDtrans(hlID('DiffText')),   'bg', 'gui')
endfunction
if has('gui_running')
    autocmd GuiEnter * call <SID>HighlightMarkerDefaultsLikeDiffHighlights()
else
    call s:HighlightMarkerDefaultsLikeDiffHighlights()
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
