let s:mappings = {
      \'<Plug>(easysearch-regex)': '<C-r><C-e>',
      \}

cnoremap <Plug>(easysearch-regex) <C-r>=<SID>invert('regex')<CR>

fu! easysearch#cmdline#read(initial)
  let s:int_pending = 0
  let s:cmdline = a:initial
  let s:cmdpos = len(s:cmdline) + 1
  let old_mapargs = s:init_mappings()
  while 1
    let str = input(s:prompt(), s:cmdline)
    if s:int_pending
      let s:int_pending = 0
      let s:cmdline .= s:get_correction()
    else
      break
    endif
  endwhile
  unlet s:int_pending

  call s:restore_mappings(old_mapargs)
  return str
endfu


fu! easysearch#cmdline#map(map, plug)
  if has_key(s:mappings, a:plug)
    let s:mappings[a:plug] = a:map
  else
    echoerr 'There is no such action: "' . a:plug . '"'
  endif
endfu


fu! s:prompt()
  let r = g:esearch_settings.stringify('regex')
  return 'pattern '.r.'>> '
endfu

fu! s:get_correction()
  if len(s:cmdline) + 1 != s:cmdpos
    return repeat("\<Left>", len(s:cmdline) + 1 - s:cmdpos )
  endif
  return ''
endfu

fu! s:init_mappings()
  let mapargs =  {}
  for plug in keys(s:mappings)
    let map = s:mappings[plug]
    let mapargs[map] = maparg(map, 'c', 0, 1)
    exe "cmap " . map . ' ' . plug
  endfor

  return mapargs
endfu

fu! s:restore_mappings(mapargs)
  for map in keys(a:mapargs)
    let maparg = a:mapargs[map]
    if empty(maparg)
      exe 'cunmap '.map
    else
      let cmd  = 'silent ' . maparg.mode . (maparg.noremap ? 'nore': '')
      let cmd .= 'map ' . maparg.lhs . maparg.rhs
      exe cmd
    endif
  endfor
endfu

fu! s:invert(option)
  let s:int_pending = 1
  let s:cmdline = getcmdline()
  let s:cmdpos = getcmdpos()
  call g:esearch_settings.invert(a:option)
  call feedkeys("\<C-c>", 'n')
  return ''
endfu
