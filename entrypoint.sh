#!/bin/bash

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
useradd -u $USER_ID -o -m docker
groupmod -g $GROUP_ID docker
export HOME=/home/docker

chown docker:docker /work

exec /usr/sbin/gosu docker "$@"
