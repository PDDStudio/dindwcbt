#!/usr/bin/env bash

RBENV_GIT_REMOTE="https://github.com/rbenv/rbenv.git"
RUBY_BUILD_GIT_REMOTE="https://github.com/rbenv/ruby-build.git"

DIR_RBENV="$HOME/.rbenv"
DIR_RUBY_BUILD="$DIR_RBENV/plugins/ruby-build"
RUBY_BUILD_INSTALLER_SCRIPT="$DIR_RUBY_BUILD/install.sh"
PATH_RBENV_BIN="$DIR_RBENV/bin"

clone_rbenv() {
  git clone "$RBENV_GIT_REMOTE" "$DIR_RBENV"
  return $?
}

clone_ruby_builder() {
  git clone "$RUBY_BUILD_GIT_REMOTE" "$DIR_RUBY_BUILD"
  return $?
}

install_builder_plugin() {
  PREFIX=$HOME/local $RUBY_BUILD_INSTALLER_SCRIPT
  return $?
}

append_local_bashrc() {
  echo "source $HOME/.bashrc.local" >> $HOME/.bashrc
  return $?
}

main() {
  case "$1" in
    git-clone)
      echo 'Cloning repositories...'
      clone_rbenv
      clone_ruby_builder
      return 0
      ;;
    install-plugin)
      echo 'Installing Ruby Build Plugin...'
      install_builder_plugin
      return $?
      ;;
    prepare-bashrc)
      echo 'Preparing .bashrc...'
      append_local_bashrc
      return $?
      ;;
    *)
      echo 'Usage: $0 { git-clone | install-plugin | prepare-bashrc }'
      return 1
      ;;
  esac
}


main "$@"
if [ $? -eq 0 ]; then
  echo 'Command execution succeeded!'
  exit 0
else
  echo 'Command returned non-zero exit code'
  exit 1
fi

