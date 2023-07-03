#!/usr/bin/env sh
set -e
export INFISICAL_TOKEN=none

COMPOSE="docker compose -f docker-compose.base.yml --env-file /dev/null"
DIGESTS="docker-compose.digests.yml"

$COMPOSE down
$COMPOSE pull
$COMPOSE create

rm -f ${DIGESTS}
touch ${DIGESTS}
## start - extract and save into file images digest

#  docker compose -f docker-compose.base.yml -f digests.yml config
echo "version: \"3.9\"" >> ${DIGESTS}
echo "services:" >> ${DIGESTS}

for SERVICE in $($COMPOSE ps  --all --services)
do
  ID=$($COMPOSE images  -q "${SERVICE}")

  if [ "$(docker inspect --format="{{index .RepoDigests}}" "$ID")" = "[]" ];
  then
    continue
  fi

  echo " \"${SERVICE}\":" >> ${DIGESTS}
  echo "    image:" $(docker inspect --format="{{index .RepoDigests 0}}" "$ID") >> ${DIGESTS}
done

## end - extract and save into file images digest
$COMPOSE down
# test
$COMPOSE -f ${DIGESTS} ps -q
$COMPOSE -f ${DIGESTS} config --no-interpolate > docker-compose.prod.yml
