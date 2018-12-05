#!/bin/bash
# find all the the *secret files and delete the unecrypted version
find . -type f -name '*secret' | while read -r SECRET ; do 
    if [ -f "${SECRET%.*}" ]; then
        rm "${SECRET%.*}"
    fi
done