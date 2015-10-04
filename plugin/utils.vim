function! UInsertHeader(d)
  let l:target = getpos("'<")[1:3]
  let l:end    = getpos("'>")[2]
  let l:line   = getline('.')[(l:target[1]-1):l:end]
  let l:length = len(l:line)
endf

function! ImprovedDelete ()
    let l:pattern = ""
    let l:char = ""
    let s:pos = -1
    let l:b = line('.')
    while l:char != 13
        redraw
        echom "/" . l:pattern
        let l:pattern .= nr2char(l:char)
        let s:pos = search(l:pattern)
        let l:char = getchar()
    endwhile
    if s:pos != -1
        execute l:b . ',' . s:pos . 'd'
    endif
endf

nmap d/ :call ImprovedDelete()<cr>
