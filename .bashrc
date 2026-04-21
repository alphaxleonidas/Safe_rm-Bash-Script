# New function. replaces rm -f with failed output

safe_rm() {
    local dangerous=false
    local critical=false
    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;  # Catches -f, -rf, -fr, etc.
        /. | /* | /*/* | /etc* | /bin* | /sbin* | /usr* | /var* | /tmp* | /dev* | /proc* | /sys* | newtest | BTRFSdrive* | NTFSdrive | Documents | Videos | Pictures | /\.\. | \.\./* | /*\.\.)
            critical=true ;;
        esac
    done

    if [ "$dangerous" = true ]; then
        echo "⚠️  Dangerous flag (-f*) detected. Operation Blocked."
        echo "   Use: rm, rm -r, or safe-rm instead."
        return 1  # Exit with error (abandons command)
    fi
    if [ "$critical" = true ]; then
        echo "⚠️  Critical Directory detected. Operation Blocked."
        return 1  # Exit with error (abandons command)
    fi


    # All other cases: use rm -i (interactive)
    echo "ℹ️  Using rm -i (interactive mode)..."
    if command -v safe-rm >/dev/null 2>&1; then
        echo "                                     Confirm deletion?(y/N)" && command safe-rm -i "$@" 
    else
        echo "                                     Confirm deletion?(y/N)" && command rm -i "$@"
    fi
}
alias rm='safe_rm'
# alias \rm='safe_rm'

```
