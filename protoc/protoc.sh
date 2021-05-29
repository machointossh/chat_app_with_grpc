#!/bin/sh

set -eux

WORKDIR=/workdir

SERVER_OUTPUT_DIR=$WORKDIR/server/messenger
CLIENT_OUTPUT_DIR=$WORKDIR/client/src/messenger

mkdir -p $SERVER_OUTPUT_DIR
mkdir -p $CLIENT_OUTPUT_DIR

protoc --version
protoc $WORKDIR/messenger.proto \
  --proto_path=$WORKDIR \
  --go_out=plugins="grpc:${SERVER_OUTPUT_DIR}" \
  --js_out=import_style=commonjs:${CLIENT_OUTPUT_DIR} \
  --grpc-web_out=import_style=typescript,mode=grpcwebtext:${CLIENT_OUTPUT_DIR}
