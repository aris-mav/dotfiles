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
    let l:text = shellescape(a:text)

    if s:term ==# 'tmux'
        call system('tmux set-buffer -b slime -- ' . l:text)
        call system('tmux paste-buffer -p -b slime -t ' . l:target)
        call system('tmux send-keys -t ' . l:target . ' Enter')
    elseif s:term ==# 'kitty'
        call system('kitten @ send-text --bracketed-paste=enable --match '
                    \ . l:target . ' -- ' . l:text)
        call system('kitten @ send-key --match ' . l:target . ' enter')
    endif
endfunction

function! SlimeOperator(type) abort
    " a:type can be 'char', 'line' or 'block'
    let l:v = {'char': 'v', 'line': 'V', 'block': "\<C-v>"}[a:type]

    " select the operated-on region using the '[ and '] marks, yank to `"s`
    execute 'silent normal! `[' . l:v . '`]"sy'

    call Slime(@s . '')
endfunction

function! s:SetOpFunc() abort
    set operatorfunc=SlimeOperator
    return 'g@'
endfunction

" <SID> allows local (s:) function to be mapped
nnoremap <expr> s <SID>SetOpFunc()
xnoremap <expr> s <SID>SetOpFunc()
nmap ss s_
