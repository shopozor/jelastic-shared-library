#! /bin/bash

if [ $# -ne 10 ] ; then
  echo "Usage: $0 hosterUrl appId login password targetEnvName targetNodeGroup targetPath sourceEnvName sourceNodeGroup sourcePath"
  echo "targetEnvName: shopozor-ci"
  echo "targetNodeGroup: cp"
  echo "targetPath: /mnt"
  echo "sourceEnvName: shopozor-management-frontend-e2e"
  echo "sourceNodeGroup: cp"
  echo "sourcePath: /home/node/reports"
  exit 0
fi

. helpers.sh

HOSTER_URL=$1
APPID=$2
SESSION=$(getSession $3 $4 ${HOSTER_URL})
TARGET_ENV_NAME=$5
TARGET_NODE_GROUP=$6
TARGET_PATH=$7
SOURCE_ENV_NAME=$8
SOURCE_NODE_GROUP=$9
SOURCE_PATH=${10}

getSourceNodeId() {
  local session=$1
  local envName=$2
  local nodeGroup=$3
  echo "Getting info about environment <$envName>..." >&2
  local cmd=$(curl -k \
    -H "${CONTENT_TYPE}" \
    -A "${USER_AGENT}" \
    -X POST \
    -fsS ${HOSTER_URL}/1.0/environment/control/rest/getenvinfo -d "envName=${envName}&session=${session}")
  echo "Got info about environment <$envName>" >&2
  echo $(echo $cmd | jq ".nodes[] | select(.nodeGroup == \"${nodeGroup}\") | .id")
}

mountRemoteFolder() {
  # mounts sourceNodeId:/home/node/reports on targetEnvName:$targetPath
  local session=$1
  local targetEnvName=$2
  local targetNodeGroup=$3
  local targetPath=$4
  local sourcePath=$5
  local readOnly="true"
  local sourceNodeId=$(getSourceNodeId $SESSION ${SOURCE_ENV_NAME} ${SOURCE_NODE_GROUP})
  echo "Mounting remote folder..." >&2
  curl -k \
    -H "${CONTENT_TYPE}" \
    -A "${USER_AGENT}" \
    -X POST \
    -fsS ${HOSTER_URL}/1.0/environment/file/rest/addmountpointbygroup -d "protocol=nfs&path=${targetPath}&envName=${targetEnvName}&session=${session}&sourceNodeId=${sourceNodeId}&readOnly=${readOnly}&nodeGroup=${targetNodeGroup}&sourcePath=${sourcePath}"
  echo "Remote folder mounted" >&2 
  exit 0
}

mountRemoteFolder $SESSION $TARGET_ENV_NAME $TARGET_NODE_GROUP $TARGET_PATH $SOURCE_PATH
