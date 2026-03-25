# bash completion for ccs (Claude Code Search)

_ccs_completions() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ ${COMP_CWORD} -eq 1 ]]; then
        # First arg: subcommands
        COMPREPLY=($(compgen -W "here cheat ls go stats doctor ix help" -- "$cur"))
        return
    fi

    case "${COMP_WORDS[1]}" in
        go)
            if [[ ${COMP_CWORD} -eq 2 ]]; then
                # Offer numbers from cache
                local cache="$HOME/.ccs_last_results"
                if [[ -f "$cache" ]]; then
                    local count
                    count=$(wc -l < "$cache" | tr -d ' ')
                    COMPREPLY=($(compgen -W "$(seq 1 "$count")" -- "$cur"))
                fi
            fi
            ;;
        ls)
            if [[ ${COMP_CWORD} -eq 2 ]]; then
                COMPREPLY=($(compgen -W "7 14 30 90" -- "$cur"))
            fi
            ;;
        *)
            # Search flags
            COMPREPLY=($(compgen -W "-d --days --since --until --date -p --project -n --limit" -- "$cur"))
            ;;
    esac
}

complete -F _ccs_completions ccs
