force_color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
# Force green prompt permanently
force_color_prompt=yes
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
. "$HOME/.cargo/env"

#alias rm='rm -i'


safe_rm() {
    local dangerous=false
    local critical=false
    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;  # Catches -f, -rf, -fr, etc.
        / | /. | /* | /*/* | /etc* | /bin* | /sbin* | /usr* | /var* | /tmp* | /dev* | /proc* | /sys* | ~/* | ~ | /\.\. | \.\./* | /*\.\.)
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
        echo "Confirm deletion?(y/N), note: ignore if file/directory absent" && command safe-rm -i "$@"
    else
        echo "Confirm deletion?(y/N), note: ignore if file/directory absent" && command rm -i "$@"
    fi
}
alias rm='safe_rm'
alias \rm='safe_rm'
alias /bin/rm='safe_rm'
