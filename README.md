# overthewire bandit solutions
my command-line solutions for the [bandit wargame](https://overthewire.org/wargames/bandit/).

this is fun to do im learning more about text filtering and navigating around a linux system.

using fish as my shell, made custom functions to automate my workflow, can be accessed ![here](scripts/).

### level 1 -> level 2
```bash
cat ./-
```

### level 2 -> level 3
```bash
cat ./--spaces\ in\ this\ filename--
```

### level 3 -> level 4
```bash
cat ./inhere/...Hiding-From-You
```

### level 4 -> level 5
```bash
cat ./inhere/-file07
```

### level 5 -> level 6
```bash
cat ./inhere/maybehere07/.file2
```

### level 6 -> level 7
```bash
cat /var/lib/dpkg/info/bandit7.password
```

### level 7 -> level 8
```bash
awk '/millionth/ {print $2}' data.txt
```

### level 8 -> level 9
```bash
sort -d data.txt | uniq -u
```

### level 9 -> level 10
```bash
strings data.txt | awk '/====/ {print $2}' | tail -n 1
```

### level 10 -> level 11
```bash
base64 -d data.txt | awk '{print $4}'
```

### level 11 -> level 12
```bash
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m' | awk '{print $4}'
```

### level 12 -> level 13

i bruteforced my way into this without realising i can use 'file' to checkout the type of compressed archive it is lol, later made a script to simplify it

![./scripts/solve12.sh](./scripts/solve12.sh)

### level 13 -> level 14

this level required transferring the private ssh key to my local machine, fixing it permissions and using it to log in

```bash
# on host
scp -P 2220 bandit13@bandit.labs.overthewire.org:sshkey.private .

chmod 700 sshkey.private

ssh -i sshkey.private bandit14@bandit.labs.overthewire.org -p 2220
```

### level 14 -> level 15

read about ports, localhost, revised ip addresses, tcp and udp protocols, went through the man pages of ssh, netcat, nmap, telnet

this level required me to send the bandit14's pass to port 30000 on localhost, which game me the pass for bandit15

```bash
nc localhost 30000
# enter the current pass for bandit14
```

### level 15 -> level 16

went through man pages of openssl, especially s_client, was quick compared to last few labs, figured out the -connect host:port thing

this level required me to send the bandit15's pass to port 30001 on localhost using ssl/tls encryption

```bash
openssl s_client -connect localhost:30001
# enter the bandit15's pass for stdin
```

### level 16 -> level 17

holy shit i went through the whole nmap man page, learnt alot but that took a lot of time, my eyes somehow caught the -sV flag very late, which was required here, but it sent it into a silent stalemate due to how the ssl/tls works on those ports.

this level required me to figure out which ports are open and speak ssl/tls between 31000 to 32000 on localhost, and pass bandit16's password to obtain credentials 

```bash
nmap -p31000-320000 localhost

# example output
# Starting Nmap 7.98 ( https://nmap.org ) at 2026-07-18 20:04 +0000
# Nmap scan report for localhost (127.0.0.1)
# Host is up (0.00014s latency).
# Other addresses for localhost (not scanned): ::1
# Not shown: 996 closed tcp ports (conn-refused)
# PORT      STATE SERVICE
# 31046/tcp open  unknown
# 31518/tcp open  unknown
# 31691/tcp open  unknown
# 31790/tcp open  unknown
# 31960/tcp open  unknown

# grab these ports and try openssl s_client on each
openssl s_client -connect localhost:31790 -quiet
# enter the password for bandit16

# ssh private key is sent back from the port, copy it onto system, chmod 700/600 on it, and use it to log into next lab

ssh -i passwords/17sshkey.private -p 2220 bandit17@bandit.labs.overthewire.org
```

### level 17 -> level 18

read diff man page, the --supress-common-files flag immediately caught my attention

this level required me to compare the only different line btw two files, which is the pass for the next lab

```bash
diff --suppress-common-files passwords.old passwords.new | awk '/>/ {print $2}'
```

unfortunately i cant login via ssh to bandit18 because someone edited the .bashrc ;-;

### level 18 -> level 19

learnt how ssh works, it spawns a full interactive shell which triggers .bashrc, and we dont spawn the login shell to bypass that

this level had the pass sitting at ~/readme, but without ssh interactive shell login, we directly execute a cmd

```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220 "cat readme"
```

### level 19 -> level 20

a simple bin file was provided to be used to run cmds as another user, we read the pass file owned by the user bandit20

```bash
./bandit20-do cat /etc/bandit_pass/bandit20
```

### level 20 -> level 21

learnt how to spin up background jobs using &, and setup netcat to listen to a specific port for the given binary to read the current pass from, and output the next pass

```bash
cat /etc/bandit_pass/bandit20 | nc -l -p 9001 &
./suconnect 9001
```

### level 21 -> level 22

read about cron, cronjobs and crontab, i picked up what to do but didnt realise i could just read the tmp files content via cat, thought my tab completion wasnt working because it didnt exit

```bash
ls /etc/cron.d/
# behemoth4_cleanup  cronjob_bandit23  leviathan5_cleanup
# clean_tmp          cronjob_bandit24  manpage3_resetpw_job
# cronjob_bandit22   e2scrub_all       otw-tmp-dir

cat /etc/cron.d/cronjob_bandit22
# @reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
# * * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null

cat /usr/bin/cronjob_bandit22.sh 
# #!/bin/bash
# chmod 644 /tmp/<filename>
# cat /etc/bandit_pass/bandit22 > /tmp/<filename>

cat /tmp/<filename>
# password output
```

### level 22 -> level 23

ezpz, look at /etc/cron.d/, figure out what the script does, pass the next username in the cmd the script uses to send the pass from /etc/bandit_pass/bandit23 to /tmp/<filename>, converts a sentence to md5sums with truncation

```bash
ls /etc/cron.d/
# behemoth4_cleanup  cronjob_bandit23  leviathan5_cleanup
# clean_tmp          cronjob_bandit24  manpage3_resetpw_job
# cronjob_bandit22   e2scrub_all       otw-tmp-dir

cat /etc/cron.d/cronjob_bandit23
# @reboot bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null
# * * * * * bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null

cat /usr/bin/cronjob_bandit23.sh
# #!/bin/bash

# myname=$(whoami)
# mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)

# echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"
# cat /etc/bandit_pass/$myname > /tmp/$mytarget

echo I am user bandit23 | md5sum | cut -d ' ' -f 1
# 8ca319486bfbbc3663ea0fbe81326349 # use this filename for /tmp

cat /tmp/8ca319486bfbbc3663ea0fbe81326349
# password output
```

### level 23 -> level 24

holy shit this was a nice jump from previous levels, had to think of an actual path to retrieve the pass
i saw what the cron job script does, figured it allows execution of files in a specific folder, i drop my one line script into that folder, which executes for the user its owned by whener the cron job runs, very clever

```bash
cat /usr/bin/cronjob_bandit24.sh
#!/bin/bash

#shopt -s nullglob

#myname=$(whoami)

#cd /var/spool/"$myname"/foo || exit 
#echo "Executing and deleting all scripts in /var/spool/$myname/foo:"
#for i in * .*;
#do
#    if [ "$i" != "." ] && [ "$i" != ".." ];
#    then
#        echo "Handling $i"
#        owner="$(stat --format "%U" "./$i")"
#        if [ "${owner}" = "bandit23" ] && [ -f "$i" ]; then
#            timeout -s 9 60 "./$i"
#        fi
#        rm -rf "./$i"
#    fi
#done

# the script basically executes and deletes all files in that folder

mkdir /tmp/blehh
chmod 777 /tmp/blehh #rwx for all so that cron runs this
cd /tmp/blehh

echo '#!/bin/bash' > exploit.sh
echo 'cat /etc/bandit_pass/bandit24 > /tmp/blehh/flag.txt' >> exploit.sh

chmod +x exploit.sh

cp exploit.sh /var/spool/bandit24/foo/

cat /tmp/bandit24_exploit/flag.txt
```


### level 24 -> level 25

learnt how to make a small brute force script against a listening daemon on a specified port via netcat.

```bash

#!/bin/bash

# make sure the location of this script is in the same dir as test.txt
mkdir -p /tmp/bruteforcingRAWR
touch /tmp/bruteforcingRAWR/test.txt

PINS="/tmp/bruteforcingRAWR/test.txt"
CURR_PASS="$(cat /etc/bandit_pass/bandit24)"

for i in {0000..9999}; do
  echo "$CURR_PASS $i" >> $PINS
done

cat $PINS | nc localhost 30002
```

make the script executable, and use awk to filter out previous failed attempts

```bash
chmod +x solve25.sh
./solve25.sh | awk '/The password of/ {print $NF}'
```

### level 25 -> level 26

literally out of the box thinking! that's something i have never even thought of before, shrinking the terminal to abuse the limits of what a software can display to override its intended function, clever level

```bash
# figure out what shell bandit26 is running by:
cat /etc/passwd | grep bandit26

# here, it is /usr/bin/showtext
cat /usr/bin/showtext
# #!/bin/sh

# export TERM=linux

# exec more ~/text.txt
# exit 0

# so i read more about more (lmao) and took a while to observe how it needs proper space to fully execute, or it pauses
# shrink your physical terminal window to be very small like 5 lines tall
# log in via ssh. the custom shell will execute 'more' and pause because the screen is too small.
ssh -i passwords/bandit26.sshkey -p 2220 bandit26@bandit.labs.overthewire.org

# while paused at the --More-- prompt, press v to spawn vim
# and the following commands get us out, had to look these up im ashamed because ive been using neovim for months and idk this ;-;
:set shell=/bin/bash
:shell
```

### level 26 -> level 27

pretty easy, a setuid binary is given for us in home dir to run commands as bandit27, we just output the password in /etc/bandit_pass/

```bash
ls -al
./bandit27-do cat /etc/bandit_pass/bandit27
```

### level 27 -> level 28

already familiar with gith, figured how ports would be included in links, password for the connection was provided

```bash
git clone ssh://bandit27-git@bandit.labs.overthewire.org:2220/home/bandit27-git/repo

# provide the bandit27 password when prompted
cd repo
cat README
```
