#!/bin/bash

set -e

message="\$REPO_URL and \$VANAGON_PROJECT are required environment variables"

if [ -z "$REPO_URL" ]; then
  echo $message
  exit 1
elif [ -z "$VANAGON_PROJECT" ]; then
  echo $message
  exit 1
fi

directory="${REPO_URL##*/}"

# clone the git repo
git clone "$REPO_URL"
cd "$directory"
git checkout "$REPO_REF"

bundle install
bundle exec /usr/local/bin/build --engine local "$@" "$VANAGON_PROJECT" el-7-x86_64

find output -type f -exec cp {} /artifacts \;
