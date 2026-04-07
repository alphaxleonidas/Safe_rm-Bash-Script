
safe_rm() {
    local dangerous=false
    local critical=false
    local recursive=false          
    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;
            / | /. | /* | /*/* | /etc* | /bin* | /sbin* | /usr* | /var* | /tmp* | /dev* | /proc* | /sys* | ~ | ~/* | /\.\. | \.\./* | /*\.\.)
                critical=true ;;
            -*r*) recursive=true ;;
        esac
    done

    if [ "$dangerous" = true ]; then
        echo "⚠️  Dangerous flag (-f) detected. Operation Blocked."
        echo "   Use: rm, rm -r, or safe_rm instead."
        return 1
    fi

    if [ "$critical" = true ]; then
        echo "⚠️  Critical directory detected. Operation Blocked."
        return 1
    fi

    if [ "$recursive" = true ]; then
        echo "You are deleting a directory. Are you sure? (y/N)"
        read -r answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            safe-rm -r "$@" && echo "Completed."
        else
            echo "Aborted."
            return 1
        fi
        return 0   # ← don't fall through to rm -i after recursive delete
    fi

    # All other cases: use rm -i (interactive)
    echo "ℹ️  Using rm -i (interactive mode)..."
    if command -v safe-rm >/dev/null 2>&1; then
        echo "You are deleting a file. Are you sure? (y/N)"
        read -r answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        command safe-rm "$@" && echo "Completed."
        else
            echo "Aborted."
            return 1        
        fi
    else
        echo "You are deleting a file. Are you sure? (y/N)"
        read -r answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        command rm -i "$@" && echo "Completed."
        else
            echo "Aborted."
            return 1
        fi
    fi
}

alias rm='safe_rm'
#alias \rm='safe_rm'
