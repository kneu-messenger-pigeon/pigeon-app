#!/usr/bin/env sh
set -e

stat docker-compose.prod.yml > /dev/null
[ -f  docker-compose.yml ] || ln -s docker-compose.prod.yml docker-compose.yml

docker compose pull
docker compose build
docker compose down
docker compose up -d

sleep 5
curl --fail  http://$(docker compose port authorizer 80)/healthcheck
