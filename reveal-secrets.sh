#!/bin/bash

# this wrapper will detected session timeout and login
oc() { 
    ./oc_wrapper.sh "$@" 
}

oc project $PROJECT 

PASSPHRASE=$(oc get secrets openshift-passphrase -o yaml | grep passphrase: | awk '{print $2}' | base64 --decode)

if [ ! -d /opt/app-root/work/.gnupg ]; then
    mkdir /opt/app-root/work/.gnupg
    chmod og-wrx /opt/app-root/work/.gnupg
    export GNUPGHOME=/opt/app-root/work/.gnupg/
    KEY=$(find . -name ocd-private.key)
    echo $PASSPHRASE | gpg --pinentry loopback --import --passphrase-fd 0 $KEY
fi

# gpg decrypt all the *secret files
find . -type f -name '*secret' | while read -r SECRET ; do 
    if [ ! -f "${SECRET%.*}" ]; then
        gpg --output "${SECRET%.*}" --decrypt "${SECRET%.*}.secret" 2>/dev/null
        if [ ! -f "${SECRET%.*}" ]; then
            echo "PANIC! could not decript ${SECRET%.*}.secret Have you git secret told the hubot user?"
            exit 1
        fi
    fi
done