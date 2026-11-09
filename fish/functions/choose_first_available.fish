function choose_first_available --argument-names candidates
    for cmd in $candidates
        if type -q $cmd
            echo $cmd
            return
        end
    end
end

