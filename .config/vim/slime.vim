if $TMUX !=# ''
    let s:term = 'tmux'
elseif $KITTY_WINDOW_ID !=# '' || $TERM =~# 'kitty'
    let s:term = 'kitty'
endif

" returns 1 if valid target exists
function! s:Target() abort
    if s:term ==# ''
        echo 'can only send text to kitty or tmux'
        return 0
    endif

    if get(g:, 'slime_target', '') ==# ''
        if s:term ==# 'tmux'
            " tmux syntax is "window.pane" (e.g. 1.3); "!" means last active pane
            let g:slime_target = input('Target tmux pane: ', '!')
        elseif s:term ==# 'kitty'
            " any kitty --match expression, e.g. title:repl or id:3
            let g:slime_target = input('Kitty target: --match ', 'title:repl')
        endif
    endif

    return g:slime_target !=# ''
endfunction

function! s:Send(text) abort
    " Quote the target so characters like "!" are safe in the shell.
    let l:target = shellescape(g:slime_target)

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
    " use register `"s` to save the selected text
    let l:previous_s_content = @s

    " Map the region type to its Visual-mode key (v, V or Ctrl-V).
    let l:v = {'char': 'v', 'line': 'V', 'block': "\<C-v>"}[a:type]
    " a:type is 'char', 'line' or 'block'.

    " Re-select the operated-on region using the '[ and '] marks, yank to `"s`.
    execute 'silent normal! `[' . l:v . '`]"sy'

    " python REPLs need a trailing newline to close indented blocks.
    let l:text = @s . (&filetype ==# 'python' ? "\n" : '')

    " restore s register
    let @s = l:previous_s_content

    if s:Target()
        call s:Send(l:text)
    endif
endfunction

function! s:SetOpFunc() abort
    set operatorfunc=SlimeOperator
    return 'g@'
endfunction

" <SID> allows local (s:) function to be mapped
nnoremap <expr> S <SID>SetOpFunc()
xnoremap <expr> S <SID>SetOpFunc()
nmap SS S_
