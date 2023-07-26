#!/usr/bin/env sh
set -e
[ -d ssl ] || [ -L ssl ] ||  mkdir ssl

docker compose pull --quiet
docker compose build --quiet
docker compose up -d --remove-orphans --timeout 180

echo ""
sleep 4

docker compose ps

PORT=$(docker compose port gateway 443)
echo "Healthcheck using public: ${PUBLIC_URL}/authorizer/healthcheck"
curl  --url "${PUBLIC_URL}/authorizer/healthcheck" --fail -I --connection-timeout 3 --max-time 5 && \
 echo "Authorizer and gateway is up" || exit 1


