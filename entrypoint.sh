#!/bin/bash
set -e

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback
USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GOURP_ID:-9001}
QUIET_MSG=${QUIET_MSG:-FALSE}

getent group user > /dev/null 2>&1 || groupadd -g $GROUP_ID worker
id -u worker > /dev/null 2>&1 || useradd --shell /bin/bash -u $USER_ID -g $GROUP_ID -o -c "" -m worker

LOCAL_UID=$(id -u worker)
LOCAL_GID=$(getent group worker | cut -d ":" -f 3)

if [ ! "$USER_ID" == "$LOCAL_UID" ] || [ ! "$GROUP_ID" == "$LOCAL_GID" ]; then
    echo "Warning: User with differing UID "$LOCAL_UID"/GID "$LOCAL_GID" already exists, most likely this container was started before with a different UID/GID. Re-create it to change UID/GID."
fi

if [ "${QUIET_MSG}" = "FALSE" ]; then
  echo "Starting with UID/GID : "$(id -u user)"/"$(getent group user | cut -d ":" -f 3)
fi

export HOME=/work

exec /usr/sbin/gosu worker "$@"
