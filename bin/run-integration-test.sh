#!/usr/bin/env sh
[ -f ssl ] || mkdir ssl

DOCKER_COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.integration-test.yml -p pigeon-app-integration-test "

$DOCKER_COMPOSE rm  --stop --force --volumes >/dev/null 2>&1
$DOCKER_COMPOSE up --renew-anon-volumes --pull --build --force-recreate --timeout 1200 --attach init-kafka --exit-code-from init-kafka

EXIT_CODE=$?
echo $EXIT_CODE

$DOCKER_COMPOSE down --remove-orphans --volumes --timeout 60 >/dev/null 2>&1
$DOCKER_COMPOSE rm  --stop --force --volumes >/dev/null 2>&1

exit $EXIT_CODE
