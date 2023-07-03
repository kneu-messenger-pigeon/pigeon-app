#!/usr/bin/env sh
set -e
COMPOSE="docker compose -f docker-compose.base.yml"

function extractImagesDigests()
{
  $COMPOSE create

  #  docker compose -f docker-compose.base.yml -f digests.yml config
  echo "version: \"3.9\""
  echo "services:"

  for SERVICE in $($COMPOSE ps  --all --services)
  do
    ID=$($COMPOSE images  -q "${SERVICE}")

    if [ "$(docker inspect --format="{{index .RepoDigests}}" "$ID")" = "[]" ];
    then
      continue
    fi

    echo " \"${SERVICE}\":"
    echo "    image:" $(docker inspect --format="{{index .RepoDigests 0}}" "$ID")
  done

  $COMPOSE down
}

$COMPOSE down
$COMPOSE pull

rm docker-composes.digests.yml
extractImagesDigests > docker-composes.digests.yml
$COMPOSE -f docker-composes.digests.yml config > docker-compose.prod.yml
