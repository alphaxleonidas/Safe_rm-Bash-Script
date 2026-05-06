safe_rm() {

# Creating local flags for case classification:

    local dangerous=false
    local critical=false
    local recursive=false

# Defining dangerous, critical, and recursive flags:

    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;  # Catches -f, -rf, -fr, etc.
        /. | /* | /*/* | /etc* | /bin* | /sbin* | /usr* | /var* | /tmp* | /dev* | /proc* | /sys* | newtest | BTRFSdrive* | NTFSdrive | Documents | Videos | Pictures | /\.\. | \.\./* | /*\.\.)
            critical=true ;;
        -*r*) recursive=true ;;
        esac
    done

# Dangerous Flag:

    if [ "$dangerous" = true ]; then
        echo "⚠️  Dangerous flag (-f*) detected. Operation Blocked."
        echo "   Use: rm, rm -r, or safe-rm instead."
        return 1  # Exit with error
    fi

# Critical Flag:

    if [ "$critical" = true ]; then
        echo "⚠️  Critical Directory detected. Operation Blocked."
        return 1  # Exit with error
    fi

# Recursive Flag:

    if [ "$recursive" = true ]; then

        echo -n "⚠️  You are about to delete a directory. Confirm deletion? [y/N]: "
        read answer
        case "${answer,,}" in
            y|yes)
                command rm -r -i -v "$@"
                return 0
                ;;
            *)
                echo "Deletion cancelled."
                return 1
                ;;
       esac
    fi

# Rest of the situations:

        echo -n " Confirm deletion? [y/N]: "
                read answer
        case "${answer,,}" in
            y|yes)
                command rm -v "$@"
                return 0
                ;;
            *)
                echo "Deletion cancelled."
                return 1
                ;;
          esac
}
# script ends

# Aliases:

alias rm='safe_rm'
alias \rm='safe_rm'

