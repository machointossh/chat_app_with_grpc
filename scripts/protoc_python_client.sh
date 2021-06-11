#!/bin/sh

set -eu

proto_path=./
python_out=python_grpc_client
grpc_python_out=python_grpc_client

python -m grpc_tools.protoc \
	--proto_path=$proto_path \
    --python_out=$python_out \
    --grpc_python_out=$grpc_python_out \
    ./proto/messenger.proto
