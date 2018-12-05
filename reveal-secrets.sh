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
        echo $PASSPHRASE | gpg --pinentry loopback --import --passphrase-fd 0 --output "${SECRET%.*}" --decrypt "${SECRET%.*}.secret"
        if [ ! -f "${SECRET%.*}" ]; then
            >&2 echo "PANIC! Could not decrypt ${SECRET%.*}.secret. Check 'git secret whoknows' against 'gpg --list-secret-keys'"
            exit 1
        fi
    fi
done