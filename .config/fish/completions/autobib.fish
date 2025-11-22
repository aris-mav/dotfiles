# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_autobib_global_optspecs
	string join \n D/database= C/config= attachments-dir= I/no-interactive read-only v/verbose q/quiet h/help V/version
end

function __fish_autobib_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_autobib_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_autobib_using_subcommand
	set -l cmd (__fish_autobib_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c autobib -n "__fish_autobib_needs_command" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_needs_command" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_needs_command" -l attachments-dir -d 'Use directory for attachments' -r -F
complete -c autobib -n "__fish_autobib_needs_command" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_needs_command" -l read-only -d 'Open the database in read-only mode'
complete -c autobib -n "__fish_autobib_needs_command" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_needs_command" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_needs_command" -s V -l version -d 'Print version'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "alias" -d 'Manage aliases'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "attach" -d 'Attach a file'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "completions" -d 'Generate a shell completions script'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "default-config" -d 'Generate configuration file'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "delete" -d 'Delete records and associated keys'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "edit" -d 'Edit existing records'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "find" -d 'Search for a citation key'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "get" -d 'Retrieve records given citation keys'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "import" -d 'Import records from a BibTeX file'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "info" -d 'Show metadata for citation key'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "local" -d 'Create or edit a local record with the given handle'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "merge" -d 'Combine multiple records'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "path" -d 'Show attachment directory associated with record'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "source" -d 'Generate records by searching for citation keys inside files'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "update" -d 'Update data associated with an existing citation key'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "util" -d 'Utilities to manage database'
complete -c autobib -n "__fish_autobib_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -f -a "add" -d 'Add a new alias'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -f -a "delete" -d 'Delete an existing alias'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -f -a "rename" -d 'Rename an existing alias'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and not __fish_seen_subcommand_from add delete rename help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from add" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from add" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from add" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from add" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from add" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from delete" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from delete" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from delete" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from rename" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from rename" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from rename" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from rename" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from rename" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add a new alias'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Delete an existing alias'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from help" -f -a "rename" -d 'Rename an existing alias'
complete -c autobib -n "__fish_autobib_using_subcommand alias; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s r -l rename -d 'Rename the file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s f -l force -d 'Overwrite an existing file with the same name'
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand attach" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand completions" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand completions" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand completions" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand completions" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand completions" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand default-config" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand default-config" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand default-config" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand default-config" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand default-config" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand default-config" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s f -l force -d 'Delete without prompting'
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand edit" -l set-eprint -d 'Set "eprint" and "eprinttype" BibTeX fields from provided fields' -r
complete -c autobib -n "__fish_autobib_using_subcommand edit" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand edit" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand edit" -l normalize-whitespace -d 'Normalize whitespace'
complete -c autobib -n "__fish_autobib_using_subcommand edit" -l strip-journal-series -d 'Strip trailing journal series'
complete -c autobib -n "__fish_autobib_using_subcommand edit" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand edit" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand edit" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand edit" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand find" -s t -l template -d 'Set the format template' -r
complete -c autobib -n "__fish_autobib_using_subcommand find" -s m -l mode -d 'The type of search to perform' -r -f -a "attachments\t'Search record attachments and print the selected path'
canonical-id\t'Search records and print the selected canonical identifier'"
complete -c autobib -n "__fish_autobib_using_subcommand find" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand find" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand find" -s s -l strict -d 'Only include records which contain all of the fields in the template'
complete -c autobib -n "__fish_autobib_using_subcommand find" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand find" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand find" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand find" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand get" -s o -l out -d 'Write output to file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand get" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand get" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand get" -s a -l append -d 'Append new entries to the output, skipping existing entries'
complete -c autobib -n "__fish_autobib_using_subcommand get" -l retrieve-only -d 'Retrieve records but do not output BibTeX or check the validity of citation keys'
complete -c autobib -n "__fish_autobib_using_subcommand get" -l ignore-null -d 'Ignore null records and aliases'
complete -c autobib -n "__fish_autobib_using_subcommand get" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand get" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand get" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand get" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand import" -s m -l mode -d 'The type of import to perform' -r -f -a "local\t'Import as `local:` records'
determine-key\t'Use automatically determined keys'
retrieve\t'Use automatically determined keys, first retrieving from remote'
retrieve-only\t'Only determine the key and retrieve from remote'"
complete -c autobib -n "__fish_autobib_using_subcommand import" -s n -l on-conflict -d 'How to resolve conflicting field values' -r -f -a "prefer-current\t'Always keep current values'
prefer-incoming\t'Overwrite current values'
prompt\t'Prompt if the there is a conflict'"
complete -c autobib -n "__fish_autobib_using_subcommand import" -l replace-colons -d 'Replace colons in entry keys with a new string' -r
complete -c autobib -n "__fish_autobib_using_subcommand import" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand import" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand import" -s A -l no-alias -d 'Never create aliases'
complete -c autobib -n "__fish_autobib_using_subcommand import" -l log-failures -d 'Print entries which could not be imported'
complete -c autobib -n "__fish_autobib_using_subcommand import" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand import" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand import" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand import" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand info" -s r -l report -d 'The type of information to display' -r -f -a "all\t'Show all info'
canonical\t'Print the canonical identifer'
valid\t'Check if the key is valid BibTeX'
equivalent\t'Print equivalent identifiers'
modified\t'Print the last modified time'"
complete -c autobib -n "__fish_autobib_using_subcommand info" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand info" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand info" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand info" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand info" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand info" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand local" -s f -l from -d 'Create local record from BibTeX file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand local" -l rename-from -d 'Rename an existing local record' -r
complete -c autobib -n "__fish_autobib_using_subcommand local" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand local" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand local" -s A -l no-alias -d 'Do not create the alias `<ID>` for `local:<ID>`'
complete -c autobib -n "__fish_autobib_using_subcommand local" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand local" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand local" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand local" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s n -l on-conflict -d 'How to resolve conflicting field values' -r -f -a "prefer-current\t'Always keep current values'
prefer-incoming\t'Overwrite current values'
prompt\t'Prompt if the there is a conflict'"
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand merge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand path" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand path" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand path" -s m -l mkdir -d 'Also create the directory'
complete -c autobib -n "__fish_autobib_using_subcommand path" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand path" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand path" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand path" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand source" -l file-type -d 'Override file type detection' -r -f -a "tex\t'TeX-style contents, such as `.tex` or `.sty` files'
txt\t'Text file, with one key per line'
aux\t'TeX-based AUX file contents, mainly `.aux` files'
bib\t'Read citation keys from a BibTeX file'"
complete -c autobib -n "__fish_autobib_using_subcommand source" -s o -l out -d 'Write output to file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand source" -s s -l skip -d 'Skip a citation key (if present)' -r
complete -c autobib -n "__fish_autobib_using_subcommand source" -l skip-from -d 'Skip citation keys which are present in the provided `.bib` file(s)' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand source" -l skip-file-type -d 'Override file type detection for skip files' -r -f -a "tex\t'TeX-style contents, such as `.tex` or `.sty` files'
txt\t'Text file, with one key per line'
aux\t'TeX-based AUX file contents, mainly `.aux` files'
bib\t'Read citation keys from a BibTeX file'"
complete -c autobib -n "__fish_autobib_using_subcommand source" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand source" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand source" -s a -l append -d 'Append new entries to the output'
complete -c autobib -n "__fish_autobib_using_subcommand source" -l retrieve-only -d 'Retrieve records but do not output BibTeX or check the validity of citation keys'
complete -c autobib -n "__fish_autobib_using_subcommand source" -l print-keys -d 'Only print the citation keys which were found (sorted and deduplicated)'
complete -c autobib -n "__fish_autobib_using_subcommand source" -l ignore-null -d 'Ignore null records and aliases'
complete -c autobib -n "__fish_autobib_using_subcommand source" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand source" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand source" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand source" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand update" -s f -l from -d 'Read update data from local path' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand update" -s n -l on-conflict -d 'How to resolve conflicting field values' -r -f -a "prefer-current\t'Always keep current values'
prefer-incoming\t'Overwrite current values'
prompt\t'Prompt if the there is a conflict'"
complete -c autobib -n "__fish_autobib_using_subcommand update" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand update" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand update" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand update" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand update" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand update" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -f -a "check" -d 'Check database for errors'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -f -a "optimize" -d 'Optimize database to (potentially) reduce storage size'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -f -a "evict" -d 'Clear all local caches'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -f -a "list" -d 'List all valid keys'
complete -c autobib -n "__fish_autobib_using_subcommand util; and not __fish_seen_subcommand_from check optimize evict list help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s f -l fix -d 'Attempt to fix errors, printing any errors which could not be fixed'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from check" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from optimize" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from optimize" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from optimize" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from optimize" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from optimize" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from optimize" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -l max-age -d 'Clear cached items which are at least `seconds` old' -r
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from evict" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s D -l database -d 'Use record database' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s C -l config -d 'Use configuration file' -r -F
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s c -l canonical -d 'Only list the canonical keys'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s I -l no-interactive -d 'Do not require user action'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Increase logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Decrease logging verbosity'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from help" -f -a "check" -d 'Check database for errors'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from help" -f -a "optimize" -d 'Optimize database to (potentially) reduce storage size'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from help" -f -a "evict" -d 'Clear all local caches'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all valid keys'
complete -c autobib -n "__fish_autobib_using_subcommand util; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "alias" -d 'Manage aliases'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "attach" -d 'Attach a file'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "completions" -d 'Generate a shell completions script'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "default-config" -d 'Generate configuration file'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "delete" -d 'Delete records and associated keys'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "edit" -d 'Edit existing records'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "find" -d 'Search for a citation key'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "get" -d 'Retrieve records given citation keys'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "import" -d 'Import records from a BibTeX file'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "info" -d 'Show metadata for citation key'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "local" -d 'Create or edit a local record with the given handle'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "merge" -d 'Combine multiple records'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "path" -d 'Show attachment directory associated with record'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "source" -d 'Generate records by searching for citation keys inside files'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "update" -d 'Update data associated with an existing citation key'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "util" -d 'Utilities to manage database'
complete -c autobib -n "__fish_autobib_using_subcommand help; and not __fish_seen_subcommand_from alias attach completions default-config delete edit find get import info local merge path source update util help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from alias" -f -a "add" -d 'Add a new alias'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from alias" -f -a "delete" -d 'Delete an existing alias'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from alias" -f -a "rename" -d 'Rename an existing alias'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from util" -f -a "check" -d 'Check database for errors'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from util" -f -a "optimize" -d 'Optimize database to (potentially) reduce storage size'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from util" -f -a "evict" -d 'Clear all local caches'
complete -c autobib -n "__fish_autobib_using_subcommand help; and __fish_seen_subcommand_from util" -f -a "list" -d 'List all valid keys'
