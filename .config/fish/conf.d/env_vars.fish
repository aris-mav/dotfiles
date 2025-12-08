for candidate in EDITOR FUZZYFIND FILE_BROWSER YANKTEXT FZF_DEFAULT_OPTS
    if not set -q {$candidate}
        switch $candidate
        case EDITOR
            set -Ux EDITOR (choose_first_available nvim vim vi hx)

            if test $EDITOR = nvim 
                set -Ux MANPAGER 'nvim +Man!'
            end

        case FUZZYFIND
            set -Ux FUZZYFIND (choose_first_available sk fzf)

        case FILE_BROWSER
            set -Ux FILE_BROWSER (choose_first_available br yazi ranger)

        case NEWT_COLORS
            set -Ux NEWT_COLORS '
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
        case YANKTEXT
            if test "$XDG_SESSION_TYPE" = "wayland"
                set -Ux YANKTEXT 'wl-copy -n'
            else if test "$XDG_SESSION_TYPE" = "x11"
                set -Ux YANKTEXT 'xclip'
            else if type -q "clip.exe"
                set -Ux YANKTEXT 'clip.exe'
            end

        case FZF_DEFAULT_OPTS
            set -Ux FZF_DEFAULT_OPTS '--height 10% --layout reverse --border none --style minimal'

        end
    end
end

if ! test "$fish_color_user" = "yellow"
    set fish_color_user yellow
    set fish_color_host cyan
    set fish_color_cwd  blue
end
