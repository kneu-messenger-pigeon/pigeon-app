#!/usr/bin/env sh
set -e

docker compose pull --quiet
docker compose build --quiet
docker compose up -d --remove-orphans

echo ""
sleep 4

docker compose ps

PORT=$(docker compose port gateway 443)
echo "Healthcheck authorizer via gateway: $PORT"
curl --fail -I https://"${PORT:-unknown}"/authorizer/healthcheck && echo "Authorizer is up" || exit 1
