#!/usr/bin/env bash
set -e

serviceListStarted=false
packagesListStarted=false
while read -r LINE; do
  if ! $serviceListStarted && ! $packagesListStarted; then
      echo "$LINE"
  fi

  # Make microservices list:
  if [ "$LINE" == "[comment]: <> (Start service list)" ]; then
      serviceListStarted=true

      echo ""
      echo "| Service | Release status | Codecov |"
      echo "|---------|----------------|---------|"

      grep -o "ghcr.io/.*" docker-compose.base.yml | sed 's/ghcr.io\///' | while read -r REPO ; do
        IFS=":" read -r REPO_NAME BRANCH <<< "$REPO"

        BRANCH=${BRANCH:-main}
        PAKCAGE_NAME="${REPO_NAME//kneu-messenger-pigeon\//}"

        README_URL="https://raw.githubusercontent.com/${REPO_NAME}/${BRANCH}/README.md"
        README_CONTENT=$(curl --fail "$README_URL" 2> /dev/null || true)

        BUILD_BADGE=$(grep "actions/workflows/.*/badge.svg" <<< "$README_CONTENT" || true)
        CODECOV_BADGE=$(grep "https://codecov.io/.*/badge.svg" <<< "$README_CONTENT" || true)

        echo "| [${PAKCAGE_NAME}](https://github.com/${REPO_NAME}) | ${BUILD_BADGE} | ${CODECOV_BADGE} |"
      done
      echo ""

  elif [ "$LINE" == "[comment]: <> (End service list)" ]; then
      serviceListStarted=false
      echo "$LINE"
  fi

  if [ "$LINE" == "[comment]: <> (Start packages list)" ]; then
      packagesListStarted=true

      echo ""
      echo "| Package | Test status | Codecov |"
      echo "|---------|-------------|---------|"

      while read -r REPO ; do
        IFS=":" read -r REPO_NAME BRANCH <<< "$REPO"

        BRANCH=${BRANCH:-main}
        PAKCAGE_NAME="${REPO_NAME//kneu-messenger-pigeon\//}"

        README_URL="https://raw.githubusercontent.com/${REPO_NAME}/${BRANCH}/README.md"
        README_CONTENT=$(curl --fail "$README_URL" 2> /dev/null || true)

        BUILD_BADGE=$(grep "actions/workflows/.*/badge.svg" <<< "$README_CONTENT" || true)
        CODECOV_BADGE=$(grep "https://codecov.io/.*/badge.svg" <<< "$README_CONTENT" || true)

        echo "| [${PAKCAGE_NAME}](https://github.com/${REPO_NAME}) | ${BUILD_BADGE} | ${CODECOV_BADGE} |"
      done< packages.txt
      echo ""

  elif [ "$LINE" == "[comment]: <> (End packages list)" ]; then
      packagesListStarted=false
      echo "$LINE"
  fi

done<README.md >tmp.README.md

rm README.md && mv tmp.README.md README.md
