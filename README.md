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

### Level 12 -> Level 13

i bruteforced my way into this without realising i can use 'file' to checkout the type of compressed archive it is lol, later made a script to simplify it

![./scripts/solve12.sh](./scripts/solve12.sh)
