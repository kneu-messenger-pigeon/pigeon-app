#!/usr/bin/env sh
# docker volume list --format {{.Name}} --filter label=com.docker.compose.project=$(basename "$PWD") | xargs docker volume rm
echo "disabled"