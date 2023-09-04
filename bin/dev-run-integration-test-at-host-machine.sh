#!/usr/bin/env sh
[ -d ssl ] || [ -L ssl ] ||  mkdir ssl

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/..

DOCKER_COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.integration-test.yml \
-p pigeon-app-integration-test --env-file .env --env-file .env.integration-test-at-host"

$DOCKER_COMPOSE rm  --stop --force --volumes
$DOCKER_COMPOSE up --renew-anon-volumes --pull --build -d --scale integration-testing=0
