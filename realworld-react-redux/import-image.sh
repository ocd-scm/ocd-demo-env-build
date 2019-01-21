#!/bin/bash
oc() { 
    ${OCD_SCRIPTS_PATH}/oc_wrapper.sh "$@" 
}
oc project $PROJECT
oc import-image nodejs-8-rhel7:latest --from='registry.access.redhat.com/rhscl/nodejs-8-rhel7:latest' --confirm
