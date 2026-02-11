set -gx EDITOR (choose_first_available nvim vim vi hx)
set -gx FUZZYFIND (choose_first_available fzf sk)
set -gx FILE_BROWSER (choose_first_available br yazi ranger)
set -gx FZF_DEFAULT_OPTS '--height 10% --layout reverse --border none --style minimal'

set -gx NEWT_COLORS '
root=green,black
window=green,black
border=green,black
shadow=black,black
title=green,black
label=green,black

textbox=green,black
acttextbox=black,green

entry=green,black
actentry=black,green

listbox=green,black
actlistbox=black,green

sellistbox=green,black
actsellistbox=black,green

checkbox=green,black
actcheckbox=black,green

helpline=green,black
roottext=green,black

button=black,green
actbutton=green,black

compactbutton=green,black
actcompactbutton=green,black
'

if test "$XDG_SESSION_TYPE" = wayland
    set -gx YANKTEXT 'wl-copy -n'
else if test "$XDG_SESSION_TYPE" = x11
    set -gx YANKTEXT 'xclip'
else if type -q clip.exe
    set -gx YANKTEXT 'clip.exe'
end

if type -q nvim
    set -gx MANPAGER "nvim +Man!"
end

if ! test "$fish_color_user" = "yellow"
    set fish_color_user yellow
    set fish_color_host cyan
    set fish_color_cwd  blue
end
