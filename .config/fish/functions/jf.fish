function jf
    set selected (jobs | $FUZZYFIND)
    if test -n "$selected"
        set jobnum (echo $selected | awk '{print $1}')
        fg %$jobnum
    end
end
