#! /bin/bash

if [ $# -ne 5 ] ; then
  echo "Usage: $0 hosterUrl appId login password envName"
  exit 0
fi

. helpers.sh

HOSTER_URL=$1
APPID=$2
PASSWORD=$4
SESSION=$(getSession $3 $4 ${HOSTER_URL})
ENV_NAME=$5

deleteEnv() {
  local session=$1
  local envName=$2
  local password=$3
  echo "Deleting environment <$envName>..." >&2
  local cmd=$(curl -k \
    -H "${CONTENT_TYPE}" \
    -A "${USER_AGENT}" \
    -X POST \
    -fsS ${HOSTER_URL}/1.0/environment/control/rest/deleteenv -d "password=${password}&session=${session}&envName=${envName}")
  exitOnFail $cmd
  echo "Environment <$envName> deleted" >&2 
  exit 0
}

deleteEnv $SESSION $ENV_NAME $PASSWORD
