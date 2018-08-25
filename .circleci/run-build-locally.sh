#!/usr/bin/env bash

prepare() {
  if [ -f "./prepare-env.sh" ]; then
    source ./prepare-env.sh
  else
    echo "Environment setup script is missing. Abort."
    exit 1
  fi
}

send_curl() {
  curl --user ${CIRCLE_TOKEN}: \
    --request POST \
    --form revision=$1\
    --form config=@config.yml \
    --form notify=false \
        https://circleci.com/api/v1.1/project/github/pddstudio/dindwcbt/tree/develop
}

main() {
  prepare
  case "$1" in
    commit | c | hash)
      echo 'Running'
      shift
      send_curl "$@"
      ;;
    *)
      echo "Usage: $0 { commit | c | hash } commit_hash"
      ;;
  esac
}

main "$@"
