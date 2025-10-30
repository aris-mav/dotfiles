# localization: skip(uses-apropos)
function ls
    # Make ls use colors and show indicators if we are on a system that supports that feature and writing to stdout.

    if not set -q __fish_ls_command
        set -g __fish_ls_command ls
        set -g __fish_ls_color_opt
        set -g __fish_ls_indicators_opt

        # Prefer lsd if installed (modern replacement for ls)
        if command -sq lsd
            set -g __fish_ls_command lsd
            # lsd always uses color by default and shows indicators, so no extra opts needed.
            # But ensure consistency with user expectations.
            set -g __fish_ls_color_opt --color=auto

        # OpenBSD ships a command called "colorls" that takes "-G" and "-F",
        # but there's also a ruby implementation that doesn't understand "-F".
        # Since that one's quite different, don't use it.
        else if command -sq colorls
            and command colorls -GF >/dev/null 2>/dev/null
            set -g __fish_ls_command colorls
            set -g __fish_ls_color_opt -G
            set -g __fish_ls_indicators_opt -F

        else
            for opt in --color=auto -G --color
                if command ls $opt / >/dev/null 2>/dev/null
                    set -g __fish_ls_color_opt $opt
                    break
                end
            end

            if command ls -F / >/dev/null 2>/dev/null
                set -g __fish_ls_indicators_opt -F
            end
        end
    end

    set -l indicators_opt
    isatty stdout
    and set -a indicators_opt $__fish_ls_indicators_opt

    test "$TERM_PROGRAM" = Apple_Terminal
    and set -lx CLICOLOR 1

    set -qx CLICOLOR_FORCE && not isatty stdout; and set __fish_ls_color_opt

    command $__fish_ls_command $__fish_ls_color_opt $indicators_opt $argv
end
