#!/usr/bin/env sh
set -e
[ -d ssl ] || [ -L ssl ] ||  mkdir ssl

docker compose pull --quiet
docker compose build --quiet
docker compose up -d --remove-orphans --timeout 180

echo ""
sleep 4

docker compose ps

HEALTHCHECK_URI="/authorizer/healthcheck"

HTTP_PORT=$(docker compose port gateway 80)
echo "Healthcheck authorizer via gateway with HTTP: $HTTP_PORT"
curl  --url "http://${HTTP_PORT:-unknown}${HEALTHCHECK_URI}" --fail -I --max-time 5 && \
 echo "Authorizer and gateway is up (http: ok)" || exit 1

HTTPS_PORT=$(docker compose port gateway 443)
echo "Healthcheck authorizer via gateway with HTTPS: $HTTPS_PORT"
curl  --url "https://${HTTPS_PORT:-unknown}${HEALTHCHECK_URI}" --fail -I --max-time 5 --insecure && \
 echo "Authorizer and gateway is up (https: ok)" || exit 1

echo "Healthcheck authorizer via gateway with Public URL: $PUBLIC_URL"
curl  --url "https://${HTTPS_PORT:-unknown}${HEALTHCHECK_URI}" --fail -I --max-time 5 && \
 echo "Authorizer and gateway is up (public: ok)" || exit 1
