# overthewire bandit solutions
my command-line solutions for the Bandit wargame.

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
aaWecNkG4FhxJQxz07uiwzVP6bJiYS65 \\bandit14's pass atm
```

### level 15 -> level 16

went through man pages of openssl, especially s_client, was quick compared to last few labs, figured out the -connect host:port thing

this level required me to send the bandit15's pass to port 30001 on localhost using ssl/tls encryption

```bash
openssl s_client -connect localhost:30001
# enter the bandit15's pass for stdin
pbLYuZtTg4MgaqfJx8jbA9gKKGqM68A7
```

### level 16 -> level 17

holy shit i went through the whole nmap man page, learnt alot but that took a lot of time, my eyes somehow caught the -sV flag very late, which was required here, but it sent it into a silent stalemate due to how the ssl/tls works on those ports.

this level required me to figure out which ports are open and speak ssl/tls between 31000 to 32000 on localhost, and pass bandit16's password to obtain credentials 

```bash
nmap -p31000-320000 localhost

# example output
<!-- Starting Nmap 7.98 ( https://nmap.org ) at 2026-07-18 20:04 +0000 -->
<!-- Nmap scan report for localhost (127.0.0.1) -->
<!-- Host is up (0.00014s latency). -->
<!-- Other addresses for localhost (not scanned): ::1 -->
<!-- Not shown: 996 closed tcp ports (conn-refused) -->
<!-- PORT      STATE SERVICE -->
<!-- 31046/tcp open  unknown -->
<!-- 31518/tcp open  unknown -->
<!-- 31691/tcp open  unknown -->
<!-- 31790/tcp open  unknown -->
<!-- 31960/tcp open  unknown -->
<!---->
# grab these ports and try openssl s_client on each
openssl s_client -connect localhost:31790 -quiet
# enter the password
kS0Hf0u5HiXFwKMKFqXvPdOTNGGa0X8V

# ssh private key is sent back from the port, copy it onto system, chmod 700/600 on it, and use it to log into next lab

ssh -i passwords/17sshkey.private -p 2220 bandit17@bandit.labs.overthewire.org
```
