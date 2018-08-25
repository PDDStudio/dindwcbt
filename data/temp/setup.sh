#!/usr/bin/env bash

prepare_rbenv() {
  rbenv install $1
  if [ $? -eq 0 ]; then
    rbenv global $1
    return $?
  else
    echo 'Failed to install Ruby via rbenv'
    exit 1
  fi
}

prepare_nvm() {
  nvm install node --latest-npm
  if [ $? -eq 0 ]; then
    nvm alias default node
    return $?
  else
    echo 'Failed to install node via nvm!'
    return 1
  fi
}

prepare_shell() {
  echo 'Installing bundler...'
  gem install bundler dpl
  local installBundler=$?
  npm i -g @pddstudio/docker-manifest
  local installDockerManifest=$?
  echo "Installing bundler returned with exit code ${installBundler}."
  echo "Installing docker-manifest returned with exit code ${installDockerManifest}."
  return 0
}

main() {
  source $HOME/.bashrc.local
  case "$1" in
    rbenv)
      echo 'Installing Ruby'
      shift
      prepare_rbenv "$@"
      return $?
      ;;
    nvm)
      echo 'Installing Node'
      prepare_nvm
      return $?
      ;;
    packages)
      echo 'Installing additional packages'
      prepare_shell
      return $?
      ;;
  esac
}

main "$@"
