#!/usr/bin/env sh
set -e
export INFISICAL_TOKEN=none

TMP_FILE=docker-compose.tmp.yml

rm -f ${TMP_FILE}
cp docker-compose.base.yml "${TMP_FILE}"

IMAGE_DIGESTS_REPLACE=""
for SERVICE in $(yq e '.services | keys  | .[]' "$TMP_FILE")
do
  IMAGE=$(yq e ".services.\"${SERVICE}\".image" "$TMP_FILE")
  DIGEST=$(crane digest  --full-ref "$IMAGE")
  echo "${SERVICE} - $DIGEST"

  yq -i ".services.\"${SERVICE}\".image = \"${DIGEST}\"" "${TMP_FILE}"
done

# validate updated config
docker compose -f ${TMP_FILE} config > /dev/null

rm -f docker-compose.prod.yml
mv ${TMP_FILE} docker-compose.prod.yml
