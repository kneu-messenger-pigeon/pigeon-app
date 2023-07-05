#!/usr/bin/env sh
set -e
DOCKER_COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.integration-test.yml -p pigeon-app-integration-test "

$DOCKER_COMPOSE down --volumes --remove-orphans --timeout 60 || true
$DOCKER_COMPOSE up --renew-anon-volumes --pull --build --force-recreate --timeout 1200 --attach init-kafka --exit-code-from init-kafka
EXIT_CODE=$?
echo $EXIT_CODE
$DOCKER_COMPOSE down --volumes --timeout 30 || true

exit $EXIT_CODE
