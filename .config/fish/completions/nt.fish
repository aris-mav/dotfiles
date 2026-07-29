# allows multiple tag completions
function __nt_using_s
    set -l tokens (commandline -opc)
    contains -- -s $tokens
end

complete -c nt -f
complete -c nt -s s -fra '(nt -T)' -d tag
complete -c nt -n __nt_using_s -fra '(nt -T)' -d tag

complete -c nt -s n -d 'create new note' -f
complete -c nt -s r -d 'revise some notes' -f
complete -c nt -s s -d 'search content' -fr
complete -c nt -s p -d 'html preview' -fr
complete -c nt -s S -d 'list sources' -fr
complete -c nt -s H -d 'list headers' -fr
complete -c nt -s T -d 'list tags' -fr
