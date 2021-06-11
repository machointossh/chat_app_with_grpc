#!/bin/sh

set -eu

cmd=$1
# opt=${@:3}

export SERVER_HOSTNAME=`sh scripts/get_lb_ip.sh`

if [ "$cmd" == "up" ]; then
    docker-compose up --build -d client
elif [ "$cmd" == "build" ];then
    docker-compose build client
else
    echo "First arguments must be 'up' or 'build'."
    exit 1
fi
