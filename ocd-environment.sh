#!/bin/bash
oc() { 
    ./oc_wrapper.sh "$@" 
}
find $(dirname $0) -name ocd-environment.yaml | while read YAML; do
  folder=$(realpath $(dirname $YAML))
  echo $folder
  # ocdEnvVersion: version of ocd-environment-webhook this configuration is compatible with
  ocdEnvVersion=$(yq .ocdEnvVersion $YAML)
  echo ocdEnvVersion=${ocdEnvVersion}
  # name: the name that helm should use
  name=$(yq .name $YAML)
  echo name=${name}
  # chart: the chart to install with
  chart=$(yq .chart $YAML)
  echo chart=${chart}
  # chartVersion: the version of the chart to use
  chartVersion=$(yq .chartVersion $YAML)
  echo chartVersion=${chartVersion}
  # helmValuesFile: the file to load chart values from
  helmValuesFile=$(yq .helmValuesFile $YAML)
  echo helmValuesFile=${helmValuesFile}
  # 
  set -x
  oc project realworld
  helm init --client-only
  helm repo list | grep ocd-meta > /dev/null
  if [ "$?" != "0" ]; then
    echo adding repo ocd-meta 
    helm repo add ocd-meta https://ocd-scm.github.io/ocd-meta/charts
  fi
  helm upgrade --install \
     -f ${helmValuesFile} \
     --version ${chartVersion} \
     --namespace realworld \
     ${name} \
     ${chart}
done
