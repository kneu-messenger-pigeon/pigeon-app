#!/usr/bin/env bash
set -e

TMP="/$TMPDIR/pigeon-app-services.md"
echo -n "" >> "$TMP"

serviceListStarted=false
while read -r LINE; do
    if [ "$serviceListStarted" = false ]; then
      echo "$LINE" >> "$TMP"
  fi


  # Assuming the strings are stored in the STR1 and STR2 variables
  if [ "$LINE" == "[comment]: <> (Start service list)" ]; then
      serviceListStarted=true

      echo "| Service | Release status | Codecov |" >> "$TMP"
      echo "|---------|----------------|---------|" >> "$TMP"

      grep -o "ghcr.io/.*" docker-compose.base.yml | sed 's/ghcr.io\///' | while read -r REPO ; do
        IFS=":" read -r REPO_NAME BRANCH <<< "$REPO"

        BRANCH=${BRANCH:-main}
        SERVICE_NAME="${REPO_NAME//kneu-messenger-pigeon\//}"

        README_URL="https://raw.githubusercontent.com/${REPO_NAME}/${BRANCH}/README.md"
        README_CONTENT=$(curl --fail "$README_URL" 2> /dev/null || true)

        BUILD_BADGE=$(grep "actions/workflows/.*/badge.svg" <<< "$README_CONTENT" || true)
        CODECOV_BADGE=$(grep "https://codecov.io/.*/badge.svg" <<< "$README_CONTENT" || true)

        echo "| [${SERVICE_NAME}](https://github.com/${REPO_NAME}) | ${BUILD_BADGE} | ${CODECOV_BADGE} |" >> "$TMP"
      done

  elif [ "$LINE" == "[comment]: <> (End service list)" ]; then
      serviceListStarted=false
      echo "$LINE" >> "$TMP"
  fi

done<README.md

rm README.md
mv "$TMP" README.md
