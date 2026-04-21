# Safe_rm Bash Script (work in progress)
Bash script to prevent accidental deletion of certain important directories.

# Safe-rm Installation
This is the safe-rm wrappper available in the apt package manager and is unrelated to my project.
```
sudo apt install safe-rm
```
This allows certain directories to be safe from ```rm``` command.

To edit the directories: (user)
```
nano ~/.safe-rm
```
To edit the directories: (System-wide)
```
sudo nano /etc/safe-rm.conf
```

Add your desired directory/path/file.

# Safe_rm Bash script Configuration

```
nano ~/.bashrc
```

Add these lines:

```
# New function. replaces rm -f with failed output

safe_rm() {
    local dangerous=false
    local critical=false
    for arg in "$@"; do
        case "$arg" in
            -*f*) dangerous=true ;;  # Catches -f, -rf, -fr, etc.
        /. | /* | /*/* | /etc* | /bin* | /sbin* | /usr* | /var* | /tmp* | /dev* | /proc* | /sys* | Documents | Videos | Pictures | /\.\. | \.\./* | /*\.\.)
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
Now to make it active:
```
source ~/.bashrc
```

# Disabling the script

To disable it: 

```
nano ~/.bashrc
```

Add this in a line above the script:
```
: <<'COMMENT'
```
And this in a line after the script:
```
COMMENT
```

Now the script is disabled.

# Caveats/Issues

1. Using ```sudo``` with the command causes both this script and ```safe-rm``` to not function. Hence, AVOID using ```sudo```.
2. For confirmation, you have to press ```y``` and then hit enter. It's how the ```rm -i``` command works.
3. May not detect the actual pathway as it only detects what is written in the argument of the command. For example, if you added ```/home/username/test*``` to the script, the script will only detect the test directory if all of it is mentioned like this. Running ```cd ~``` and ```rm -r test``` will delete the folder. To prevent that use ```test*``` in the script. Still revieweing the criteria.
4. This script is very tricky to apply. You might have to comment out the script and then restart. 
