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
                set -U EDITOR (choose_first_available nvim vim vi hx)
            case FUZZYFIND
                set -U FUZZYFIND (choose_first_available sk fzf)
            case FILE_BROWSER
                set -U FILE_BROWSER (choose_first_available br yazi ranger)
        end
    end
end

if ! test "$fish_color_user" = "yellow"
    set fish_color_user yellow
    set fish_color_host cyan
    set fish_color_cwd  blue
end
