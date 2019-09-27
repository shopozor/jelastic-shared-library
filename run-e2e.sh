#! /bin/bash

if [ $# -lt 5 ] ; then
  echo "Usage: $0 hosterUrl appId login password envName [deploy_group = cp] [path-to-manifest = e2e.jps]"
  exit 0
fi

. helpers.sh

HOSTER_URL=$1
APPID=$2

SESSION=$(getSession $3 $4 ${HOSTER_URL})
ENV_NAME=$5
DEPLOY_GROUP=${6:-cp}
MANIFEST=${7:-e2e.jps}

runE2e() {
  ENVS=$(getEnvs $SESSION)

  startEnvIfNecessary $SESSION "${ENV_NAME}" "$ENVS"
  installEnv $SESSION "${ENV_NAME}" "$MANIFEST"

  exit 0
}

runE2e
