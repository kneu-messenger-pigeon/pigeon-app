#!/usr/bin/env sh
set -e

git fetch
# git diff --name-status @ @{upstream} docker-compose.prod.yml | grep docker-compose.prod.yml || echo "docker-compose.prod.yml not changed" && exit 8

git pull

COMPOSE="docker compose -f docker-compose.base.yml"

$COMPOSE pull
$COMPOSE build
$COMPOSE down
$COMPOSE up -d

sleep 5
curl --fail  http://$($COMPOSE port authorizer 80)/healthcheck
