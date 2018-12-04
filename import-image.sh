#!/bin/bash
oc() { 
    ./oc_wrapper.sh "$@" 
}
oc project $PROJECT
oc import-image nodejs-8-rhel7:1-31 --from='registry.access.redhat.com/rhscl/nodejs-8-rhel7:1-31' --confirm
PROJECT=$(oc project --short)
oc tag $PROJECT/nodejs-8-rhel7:1-31 $PROJECT/nodejs-8-rhel7:latest
