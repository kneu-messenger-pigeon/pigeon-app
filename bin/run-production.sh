#!/usr/bin/env sh
set -e

echo "Authorizer port from variable: $AUTHORIZER_PORT"
if [ -z "$AUTHORIZER_PORT" ] && command -v yq >/dev/null 2>&1; then
  if [ -f docker-compose.prod.yml ]; then
    AUTHORIZER_PORT=$(yq -e '.services.authorizer.ports[0]' docker-compose.prod.yml )
  else
    AUTHORIZER_PORT=$(yq -e '.services.authorizer.ports[0]' docker-compose.yml )
  fi

  AUTHORIZER_PORT=$(echo "$AUTHORIZER_PORT" | cut -d':' -f2)
  echo "Authorizer port from docker compose yml: $AUTHORIZER_PORT"
fi

docker compose pull --quiet
docker compose build --quiet
docker compose up -d --remove-orphans

echo ""
sleep 4

echo "Healthcheck authorizer"
PORT=$(docker compose port authorizer "${AUTHORIZER_PORT:-8890}")
curl --fail -s  http://"${PORT:-unknown}"/healthcheck && echo "Authorizer is up" || exit 1
