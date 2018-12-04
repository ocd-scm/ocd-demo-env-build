#!/bin/bash
oc() { 
    ./oc_wrapper.sh "$@" 
}
oc project $PROJECT
helm repo list
if [ "$?" != "0" ]; then
  helm init --client-only  
fi
find $(dirname $0) -name helmfile.yaml | while read YAML; do
  folder=$(realpath $(dirname $YAML))
  echo $folder
  pushd $folder
  # 
  set -x
  helmfile --log-level debug apply
  popd
done
