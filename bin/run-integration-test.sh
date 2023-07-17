#!/usr/bin/env sh
DOCKER_COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.integration-test.yml -p pigeon-app-integration-test "
which infisical || exit 20
$DOCKER_COMPOSE down --volumes --timeout 30 >/dev/null 2>&1

infisical run --env=integration-testing -- \
$DOCKER_COMPOSE up --renew-anon-volumes --pull --build --force-recreate --timeout 1200 --attach init-kafka --exit-code-from init-kafka

EXIT_CODE=$?
echo $EXIT_CODE

$DOCKER_COMPOSE down --volumes --timeout 60 >/dev/null 2>&1

exit $EXIT_CODE
