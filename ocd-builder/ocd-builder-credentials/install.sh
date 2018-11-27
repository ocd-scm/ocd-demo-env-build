#!/bin/bash

$( $(cat credentials.env | sed 's/^export /g') )

# make sure we have the ocd-builder-credentials to tag the resultant image
helm upgrade --install \
    --set server=$OPENSHIFT_SERVER,user=$OPENSHIFT_USER,password=$OPENSHIFT_PASSWORD \
    ocd-builder-credentials \
    ocd-meta/ocd-builder-credentials