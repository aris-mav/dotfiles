set -gx EDITOR (choose_first_available nvim vim vi hx)
set -gx FUZZYFIND (choose_first_available fzf sk)
set -gx FILE_BROWSER (choose_first_available br yazi ranger)
set -gx FZF_DEFAULT_OPTS '--height 10% --layout reverse --border none --style minimal'

set -gx NEWT_COLORS '
root=,black
window=white,black
border=orange,black
shadow=,black
title=brightyellow,black
textbox=white,black
label=brightwhite,black
listbox=white,black
actlistbox=black,brightblack
button=black,brightyellow
actbutton=black,brightgreen
entry=white,black
disentry=brightblack,black
'

if test "$XDG_SESSION_TYPE" = wayland
    set -gx YANKTEXT 'wl-copy -n'
else if test "$XDG_SESSION_TYPE" = x11
    set -gx YANKTEXT 'xclip'
else if type -q clip.exe
    set -gx YANKTEXT 'clip.exe'
end

if type -q bat
    set -gx MANPAGER "bat -plman"
else if type -q batcat
    set -gx MANPAGER "batcat -plman"
else if type -q nvim
    set -gx MANPAGER "nvim +Man!"
else
    set -gx MANPAGER "less --use-color -Dd+r -Du+b"
end

if ! test "$fish_color_user" = "yellow"
    set fish_color_user yellow
    set fish_color_host cyan
    set fish_color_cwd  blue
end
