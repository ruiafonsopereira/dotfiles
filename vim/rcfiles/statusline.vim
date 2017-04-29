" See: https://github.com/neomake/neomake/blob/master/doc/neomake.txt#L407
function! NeomakeStatus()
  let prefix = ' '.emoji#for('x').' '
  return neomake#statusline#LoclistStatus(prefix)
endfunction

function! Modified()
  if &modified
    return emoji#for('construction').' '
  else
    return ''
  endif
endfunction

function! GitBranch()
  let l:head = fugitive#head()
    if empty(l:head)
      return ''
    else
      " return emoji#for('arrows_clockwise').l:head
      return l:head
    endif
endfunction

function! GitHunks()
  let hunks  = GitGutterGetHunkSummary()
  let string = ''

  if !empty(hunks)
    let hunk_symbols = ['+', '~', '-']

    for i in [0, 1, 2]
      if hunks[i] > 0
        let string .= printf('%s%s ', hunk_symbols[i], hunks[i])
      endif
    endfor
  endif
  return string
endfunction

hi def link User1 TablineFill
function! StatusLine()
  let buf         = " [%n]"
  let make_status = "%{NeomakeStatus()}"
  let fpath       = " %<%f "
  let mod         = "%{Modified()}"
  let spell       = "%{&spell ? emoji#for('mag') . ' ' : ''}"
  let ro          = "%{&readonly ? emoji#for('lock') . ' ' : ''}"
  " Use 4l as a little trick to avoid issues of emojis being rendered above
  " previous chars.
  let pos         = " %4l,%-3c %P "
  let sep         = " %= "
  let gb          = "%{GitBranch()} "
  let gh          = "%{GitHunks()}"

  return buf.make_status.fpath.ro.mod.spell.pos.sep.sep.gb.gh
endfunction

" Note that the "%!" expression is evaluated in the context of the
" current window and buffer, while %{} items are evaluated in the
" context of the window that the statusline belongs to.
set statusline=%!StatusLine()