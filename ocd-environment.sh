#!/bin/bash
VERSION=1.0.0
oc() { 
    ./oc_wrapper.sh "$@" 
}
oc project $PROJECT
find $(dirname $0) -name helmfile.yaml | while read YAML; do
  folder=$(realpath $(dirname $YAML))
  echo $folder
  pushd $folder
  # 
  set -x
  oc project ${PROJECT}
  helmfile --log-level debug apply
  popd
done
