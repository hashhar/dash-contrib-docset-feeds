set nocompatible

function! Mirror(dict)
  for [key, value] in items(a:dict)
    let a:dict[value] = key
  endfor
  return a:dict
endfunction

function! S(number)
  return submatch(a:number)
endfunction

function! SwapWords(dict, ...)
  let words = keys(a:dict) + values(a:dict)
  let words = map(words, 'escape(v:val, "|")')
  if(a:0 == 1)
    let delimiter = a:1
  else
    let delimiter = '/'
  endif
  let pattern = '\v(' . join(words, '|') . ')'
  exe '%s' . delimiter . pattern . delimiter
      \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
      \ . delimiter . 'g'
endfunction

function! FixFileUrl()
  exe 0
  let @q = 'jf>l"ayt<j$2F/l"byt<'
  normal @q
  call SwapWords({@a:@b})
endfunction

