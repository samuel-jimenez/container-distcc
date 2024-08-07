#!/bin/sh

# location of config file
${ENV_FILE:=${HOME}/containers/distcc/distccd.conf}

# read config
set -o allexport && source $ENV_FILE && set +o allexport

# start container
podman run -d -p 3632:3632 -p 3633:3633 --replace --name=distcc  distcc /usr/bin/distccd --no-detach --daemon --stats --log-level=warning --log-stderr $DISTCC_ARGS

