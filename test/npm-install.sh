#!/usr/bin/env bash

TARGET_PACKAGES=(npm @angular/cli hotel)

install() {
  for pkg in $TARGET_PACKAGES
  do
    bash -l -c "npm install --global $pkg"
    echo "Command returned with exit code: $?"
  done
}

install
