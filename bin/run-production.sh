#!/usr/bin/env sh
set -e
[ -f ssl ] || mkdir ssl

docker compose pull --quiet
docker compose build --quiet
docker compose up -d --remove-orphans --timeout 180

echo ""
sleep 4

docker compose ps

PORT=$(docker compose port gateway 443)
echo "Healthcheck authorizer via gateway: $PORT"
curl  --url https://"${PORT:-unknown}"/authorizer/healthcheck --fail -I --connection-timeout 3 --max-time 5 && \
 echo "Authorizer is up" || exit 1
