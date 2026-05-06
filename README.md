# Safe_rm Bash Script
Bash script to prevent accidental deletion of certain important directories.

For Fish Script, use : [Safe_rm-Fish-Script](https://github.com/alphaxleonidas/Safe_rm-Fish-Script)

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
echo $SHELL
```
output: /bin/bash

```
cd ~
git clone https://github.com/alphaxleonidas/Safe_rm-Bash-Script/
rm -r Safe_rm-Bash-Script/backups
cp -r Safe_rm-Bash-Script/* ~/
source ~/.bashrc
```
This will activate the script.

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
Activate the new .bashrc
```
source .bashrc
```

Now the script is disabled.

# Caveats/Issues

1. Using ```sudo``` with the command causes both this script and ```safe-rm``` to not function. Hence, AVOID using ```sudo```.
2. For confirmation, you have to press ```y``` and then hit enter. It's how the ```rm -i``` command works.
3. May not detect the actual pathway as it only detects what is written in the argument of the command. For example, if you added ```/home/username/test*``` to the script, the script will only detect the test directory if all of it is mentioned like this. Running ```cd ~``` and ```rm -r test``` will delete the folder. To prevent that use ```test*``` in the script. Still revieweing the criteria.
4. This script is very tricky to apply. You might have to comment out the script and then restart. 
