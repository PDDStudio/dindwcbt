#!/usr/bin/env bash

# Startup script to initialize rbenv.
# This file will be loaded by the environment via profile & profile.d scripts.
# This file is expected be placed in /etc/profile.d/
echo rbenv-init: Running as $(whoami) with home directory $HOME
source $HOME/.bashrc.local
eval "$(. $HOME/.bashrc && rbenv init -)"