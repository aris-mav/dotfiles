if $TMUX !=# ''
    let s:term = 'tmux'
elseif $KITTY_WINDOW_ID !=# '' || $TERM =~# 'kitty'
    let s:term = 'kitty'
endif

function! s:TargetSelect() abort
    if s:term ==# ''
        echo 'can only send text to kitty or tmux'
        return 0
    endif

    if get(b:, 'slime_target', '') ==# ''
        if s:term ==# 'tmux'
            " tmux syntax is "window.pane" (e.g. 1.3); "!" means last active pane
            let b:slime_target = input('Target tmux pane: ', '!')
        elseif s:term ==# 'kitty'
            " any kitty --match expression, e.g. title:repl or id:3
            let b:slime_target = input('Kitty target: --match ', 'title:repl')
        endif
    endif

    return b:slime_target !=# '' " returns 1 only if valid target exists
endfunction

function! Slime(text) abort
    if !s:TargetSelect()
        return
    endif

    let l:target = shellescape(b:slime_target)

    if s:term ==# 'tmux'
        call system('tmux set-buffer -b slime -- ' . shellescape(a:text))
        call system('tmux paste-buffer -p -b slime -t ' . l:target)
        call system('tmux send-keys -t ' . l:target . ' Enter')
    elseif s:term ==# 'kitty'
        call system('kitten @ send-text --bracketed-paste=enable --match '
                    \ . l:target . ' ' . shellescape(a:text))
        call system('kitten @ send-key --match ' . l:target . ' enter')
    endif
endfunction

function! SlimeOperator(type) abort

    " Map the region type to its Visual-mode key (v, V or Ctrl-V).
    let l:v = {'char': 'v', 'line': 'V', 'block': "\<C-v>"}[a:type]
    " a:type is 'char', 'line' or 'block'.

    " Re-select the operated-on region using the '[ and '] marks, yank to `"s`.
    execute 'silent normal! `[' . l:v . '`]"sy'

    " python REPLs need a trailing newline to close indented blocks.
    let l:text = @s . (&filetype ==# 'python' ? "\n" : '')

    call Slime(l:text)
endfunction

function! s:SetOpFunc() abort
    set operatorfunc=SlimeOperator
    return 'g@'
endfunction

" <SID> allows local (s:) function to be mapped
nnoremap <expr> s <SID>SetOpFunc()
xnoremap <expr> s <SID>SetOpFunc()
nmap ss s_
