#!/usr/bin/env sh
[ -d ssl ] || [ -L ssl ] ||  mkdir ssl

DOCKER_COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.integration-test.yml -p pigeon-app-integration-test "

$DOCKER_COMPOSE down --volumes --remove-orphans --timeout 30 >/dev/null 2>&1
$DOCKER_COMPOSE up --pull missing --build --force-recreate --timeout 500 --attach integration-testing --exit-code-from integration-testing

EXIT_CODE=$?
echo $EXIT_CODE

$DOCKER_COMPOSE down --volumes --timeout 30 >/dev/null 2>&1

exit $EXIT_CODE
