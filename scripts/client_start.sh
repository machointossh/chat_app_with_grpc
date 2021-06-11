#!/bin/sh

set -eu

export SERVER_HOSTNAME=`sh scripts/get_lb_ip.sh`
docker-compose up --build -d client
