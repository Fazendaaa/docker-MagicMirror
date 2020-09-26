#!/bin/sh
set -e

# https://stackoverflow.com/a/51761312/4934537
latest_release=$(git ls-remote --tags --refs --sort="v:refname" https://github.com/MichMich/MagicMirror.git | tail -n1 | sed 's/.*\///')
if [ "$(docker manifest inspect fazenda/docker-magicmirror:"${latest_release}" > /dev/null; echo $?)" != 0 ]; then
  docker buildx build \
  --progress plain \
  --platform=linux/amd64,linux/arm64,linux/arm/v7 ${1} \
  --build-arg branch="${latest_release}" \
  --push -t fazenda/docker-magicmirror:"${latest_release}" \
  --push -t fazenda/docker-magicmirror:latest .
fi

docker buildx build --progress plain \
--platform=linux/amd64,linux/arm64,linux/arm/v7 ${1} \
--build-arg branch=develop \
--push -t fazenda/docker-magicmirror:develop .
