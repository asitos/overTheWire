#!/bin/bash

WORK_DIR=$(mktemp -d) 
cd $WORK_DIR

cp ~/data.txt .
xxd -r data.txt > current_file
rm data.txt

echo "starting decompression in $WORK_DIR..."

while true; do
  FILE_TYPE=$(file -b current_file)

  echo "current file type: $FILE_TYPE"

  if [[ "$FILE_TYPE" == *"gzip compressed data"* ]]; then
    mv current_file current_file.gz
    gzip -d current_file.gz

  elif [[ "$FILE_TYPE" == *"bzip2 compressed data"* ]]; then
    mv current_file current_file.bz2
    bzip2 -d current_file.bz2

  elif [[ "$FILE_TYPE" == *"POSIX tar archive"* ]]; then
    mv current_file current_file.tar
    tar -xf current_file.tar

    rm current_file.tar
    NEW_FILE=$(ls) 
    mv $NEW_FILE current_file

  elif [[ "$FILE_TYPE" == *"ASCII text"* ]]; then
    echo -e "\n password found"
      cat current_file
    break

  else 
    echo "error"
    break
  fi
done


