#!/usr/bin/env bash

echo "RUNNING AS USER: $(whoami)"
echo "WORKING DIRECTORY: $(pwd)"
exec "$@"
