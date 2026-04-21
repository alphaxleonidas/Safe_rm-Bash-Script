safe_rm() {
    local dangerous=false
    local critical=false
    local recursive=false
    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;  # Catches -f, -rf, -fr, etc.
        /. | /* | /*/* | /etc* | /bin* | /sbin* | /usr* | /var* | /tmp* | /dev* | /proc* | /sys* | newtest | BTRFSdrive* | NTFSdrive | Documents | Videos | Pictures | /\.\. | \.\./* | /*\.\.)
            critical=true ;;
        -*r*) recursive=true ;;
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
    if [ "$recursive" = true ]; then

        echo -n "⚠️  You are about to delete a directory. Confirm deletion? [y/N]: "
        read answer
        case "${answer,,}" in
            y|yes)
                command rm -r -i "$@"
                echo "Directory deleted."
                return 0
                ;;
            *)
                echo "Deletion cancelled."
                return 1
                ;;
       esac
    fi


    # All other cases: use rm -i (interactive)
#    echo "ℹ️  Using interactive mode"
 
    if command -v safe-rm >/dev/null 2>&1; then
        echo -n " Confirm deletion? [y/N]: "
                read answer
        case "${answer,,}" in
            y|yes)
                command safe-rm "$@"
                echo "File deleted."
                return 0
                ;;
            *)
                echo "Deletion cancelled."
                return 1
                ;;
          esac
    else
        echo -n " Confirm deletion? [y/N]: "
                read answer
        case "${answer,,}" in
            y|yes)
                command rm "$@"
                echo "File deleted."
                return 0
                ;;
            *)
                echo "Deletion cancelled."
                return 1
                ;;
          esac
    fi
}
alias rm='safe_rm'
# alias \rm='safe_rm'

