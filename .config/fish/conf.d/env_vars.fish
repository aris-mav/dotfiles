function choose_first_available --argument-names candidates
    for cmd in $candidates
        if type -q $cmd
            echo $cmd
            return
        end
    end
end

for candidate in EDITOR FUZZYFIND FILE_BROWSER
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
        end
    end
end

if ! test "$fish_color_user" = "yellow"
    set fish_color_user yellow
    set fish_color_host cyan
    set fish_color_cwd  blue
end
