#!/bin/bash
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
  # setEnvVarTemplate: how to map env vars into the helm set parameter
  setEnvVarTemplate=$(yq .setEnvVarTemplate $YAML)
  echo setEnvVarTemplate=${setEnvVarTemplate}
  env=$folder/env  
  set -a
  [ -f $env ] && . $env
  set +a
  setParam=$(echo $setEnvVarTemplate | envsubst)
  echo setParam=${setParam}
  
done
