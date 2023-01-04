#!/usr/bin/env bash
set -x
set -eo pipefail

POSTGRES_CONTAINER_ID="$(docker container ls  | grep 'postgres' | awk '{print $1}')"

docker stop "${POSTGRES_CONTAINER_ID}"
docker rm "${POSTGRES_CONTAINER_ID}"
