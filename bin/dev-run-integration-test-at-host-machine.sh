#!/usr/bin/env sh
[ -d ssl ] || [ -L ssl ] ||  mkdir ssl

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/..

DOCKER_COMPOSE="docker compose -f docker-compose.base.yml -f docker-compose.integration-test.yml \
-p pigeon-app-integration-test --profile kafka-ui-enabled \
--env-file .env --env-file .env.integration-test-at-host"


$DOCKER_COMPOSE down --volumes --remove-orphans --timeout 30
$DOCKER_COMPOSE up --pull --build --force-recreate -d --scale integration-testing=0

