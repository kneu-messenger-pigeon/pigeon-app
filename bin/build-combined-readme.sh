#!/usr/bin/env bash
set -e

serviceListStarted=false
packagesListStarted=false

SERVICES=$(grep -o "ghcr\.io/.*" docker-compose.base.yml | sed 's/ghcr\.io\///')

while IFS= read -r LINE; do
  if ! $serviceListStarted && ! $packagesListStarted; then
      echo "$LINE"
  fi

  # Make microservices list:
  if [ "$LINE" == "[comment]: <> (Start service list)" ]; then
      serviceListStarted=true

      echo ""
      echo "| Service | Release status | Codecov |"
      echo "|---------|----------------|---------|"

      while read -r REPO ; do
        >&2 echo "Put service ${REPO} to readme"
        IFS=":" read -r REPO_NAME BRANCH <<< "$REPO"

        BRANCH=${BRANCH:-main}
        PACKAGE_NAME="${REPO_NAME//kneu-messenger-pigeon\//}"

        README_URL="https://raw.githubusercontent.com/${REPO_NAME}/${BRANCH}/README.md"
        README_CONTENT=$(curl --fail "$README_URL" 2> /dev/null || true)

        BUILD_BADGE=$(grep "actions/workflows/.*/badge.svg" <<< "$README_CONTENT" || true)
        CODECOV_BADGE=$(grep "https://codecov.io/.*/badge.svg" <<< "$README_CONTENT" || true)

        echo "| [${PACKAGE_NAME}](https://github.com/${REPO_NAME}) | ${BUILD_BADGE} | ${CODECOV_BADGE} |"
      done <<< "$SERVICES"
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

      while IFS= read -r REPO ; do
          >&2 echo "Get packages of service ${REPO}"

          IFS=":" read -r REPO_NAME BRANCH <<< "$REPO"

          GO_MOD_URL="https://raw.githubusercontent.com/${REPO_NAME}/${BRANCH}/go.mod"

          # print used pckages
          curl --fail "$GO_MOD_URL" 2> /dev/null | \
            grep -v "module " | \
            grep -o "github.com/kneu-messenger-pigeon/\S*\|github.com/\S*kneu\S*" | \
            sed 's/github\.com\///' || true

      done <<< "$SERVICES" | sort -r -u | \
      while IFS= read -r REPO ; do
        >&2 echo "Put package ${REPO} to readme"
        IFS=":" read -r REPO_NAME BRANCH <<< "$REPO"

        BRANCH=${BRANCH:-main}
        PACKAGE_NAME="${REPO_NAME//kneu-messenger-pigeon\//}"

        README_URL="https://raw.githubusercontent.com/${REPO_NAME}/${BRANCH}/README.md"
        README_CONTENT=$(curl --fail "$README_URL" 2> /dev/null || true)

        BUILD_BADGE=$(grep "actions/workflows/.*/badge.svg" <<< "$README_CONTENT" || true)
        CODECOV_BADGE=$(grep "https://codecov.io/.*/badge.svg" <<< "$README_CONTENT" || true)

        echo "| [${PACKAGE_NAME}](https://github.com/${REPO_NAME}) | ${BUILD_BADGE} | ${CODECOV_BADGE} |"
      done 

      echo ""

  elif [ "$LINE" == "[comment]: <> (End packages list)" ]; then
      packagesListStarted=false
      echo "$LINE"
  fi

done<README.md >tmp.README.md

rm README.md && mv tmp.README.md README.md
