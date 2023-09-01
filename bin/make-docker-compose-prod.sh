#!/usr/bin/env sh
set -e
export INFISICAL_TOKEN=none

TMP_FILE=docker-compose.tmp.yml

rm -f ${TMP_FILE}
cp docker-compose.base.yml "${TMP_FILE}"

yq -e '.services | keys  | .[]' "$TMP_FILE" | while read -r SERVICE;
do
  IMAGE=$(yq -e ".services.\"${SERVICE}\".image" "$TMP_FILE")
  # Remove the substrings 'index.docker.io/library/' and 'index.docker.io/' using sed
  DIGEST=$(crane digest  --full-ref "$IMAGE" | sed -e 's/index\.docker\.io\/library\///' -e 's/index\.docker\.io\///' )
  echo "${SERVICE} - $DIGEST"

  yq -i ".services.\"${SERVICE}\".image = \"${DIGEST}\"" "${TMP_FILE}"
done

# validate updated config
docker compose -f ${TMP_FILE} config > /dev/null

rm -f docker-compose.prod.yml
mv ${TMP_FILE} docker-compose.prod.yml
