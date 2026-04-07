safe_rm() {
    local dangerous=false
    local critical=false
    local recursive=false

    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;
            / | /. | /* | /*/* | \
            /etc* | /bin* | /sbin* | /usr* | /var* | \
            /tmp* | /dev* | /proc* | /sys* | \ | /\\.\\. | \\.\\./* | /*\\.\\.)
                critical=true ;;
            -*r*) recursive=true ;;
        esac
    done

    # Block dangerous flags
    if [ "$dangerous" = true ]; then
        echo "⚠️  Dangerous flag (-f) detected. Operation Blocked."
        echo "   Use: rm, rm -r, or safe_rm instead."
        return 1
    fi

    # Block critical paths
    if [ "$critical" = true ]; then
        echo "⚠️  Critical directory detected. Operation Blocked."
        return 1
    fi

    if [ $"recursive" = true ]; then
    echo "You are deleting a DIRECTORY. Are you sure? (y/N)"
    else
    # Interactive confirmation prompt (reusable)
    echo "You are deleting a file. Are you sure? (y/N)"
    fi
    read -r answer
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        echo "Aborted."
        return 1
    fi

    # Decide cmd: prefer safe‑rm; fall back to rm
    local rm_cmd="rm"
    if command -v safe-rm >/dev/null 2>&1; then
        rm_cmd="safe-rm"
    fi

    # Run with -r flag if needed
    if [ "$recursive" = true ]; then
        "$rm_cmd" -r "$@" && echo "Completed." || return 1
    else
        "$rm_cmd" "$@" && echo "Completed." || return 1
    fi
}

alias rm='safe_rm'
#alias \rm='safe_rm'
