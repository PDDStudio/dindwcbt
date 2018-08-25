#!/usr/bin/env bash

source_rc() {
  source $HOME/.bashrc
}

print_summary() {
  echo "Installation complete!"
  echo "==== BEGIN ENV SETUP ===="
  echo "docker Version: $(docker version)"
  echo "docker-compose Version: $(docker-compose version)"
  echo "docker-manifest Verion: $(docker-manifest version)"
  echo "node Version: $(node -v)"
  echo "npm Version: $(npm -v)"
  echo "ruby Version: $(ruby -v)"
  echo "rbenv Version: $(rbenv -v)"
  echo "gem Version: $(gem -v)"
  echo "bundler Version: $(bundle -v)"
  echo "==== END ENV SETUP ===="
}

source_rc
print_summary
exit 0