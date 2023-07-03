#!/usr/bin/env sh
set -e

if [ "$1" != "force" ]; then
  git fetch
  git diff --name-status @ @{upstream} docker-compose.prod.yml | grep docker-compose.prod.yml || echo "docker-compose.prod.yml not changed" && exit 8
fi

git pull

stat docker-compose.prod.yml > /dev/null
rm -f docker-compose.yml
cp docker-compose.prod.yml docker-compose.yml

docker compose pull
docker compose build
docker compose down
docker compose up -d

sleep 5
curl --fail  http://$(docker compose port authorizer 80)/healthcheck
