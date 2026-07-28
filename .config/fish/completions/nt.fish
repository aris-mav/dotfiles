# allows multiple tag completions
function __nt_using_s
    set -l tokens (commandline -opc)
    contains -- -s $tokens
end

complete -c nt -f
complete -c nt -s s -fra '(nt -T)' -d tag
complete -c nt -n __nt_using_s -fra '(nt -T)' -d tag

complete -c nt -s n -d 'create new note' -f
complete -c nt -s t -d 'open TODO.txt' -f
complete -c nt -s b -d 'log finished book' -f

complete -c nt -s s -d 'content search' -fr
complete -c nt -s f -d 'file search' -fra '(ls $NOTES_DIR)'
complete -c nt -s p -d 'html preview' -fra '(ls $NOTES_DIR)'

complete -c nt -s S -d 'list sources' -fra '(ls $NOTES_DIR)'
complete -c nt -s H -d 'list headers' -fra '(ls $NOTES_DIR)'
complete -c nt -s T -d 'list tags' -fra '(ls $NOTES_DIR)'
