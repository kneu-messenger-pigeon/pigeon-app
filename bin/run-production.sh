#!/usr/bin/env sh
set -e

docker compose pull --quiet
docker compose build --quiet
docker compose down --remove-orphans
docker compose up -d

sleep 7
PORT=$(docker compose port authorizer ${{ AUTHORIZER_PORT:-8890 }})
curl --fail -s  http://"${PORT:-unknown}"/healthcheck
