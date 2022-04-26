#!/usr/bin/env bash

set -euo pipefail

# After moving to ruby-25-centos7 we end up with a .bundle directory in pwd
# which we need to remove for the original builder script to execute correctly
if [[ -d '.bundle' ]]; then
  echo "Removing .bundle directory from `pwd`"
  rm -rf .bundle
fi

# /opt/app-root/src must be empty, otherwise assemble fails
if [[ -d './bin' ]]; then
  echo "Removing bin directory from `pwd`"
  rm -rf ./bin
fi

if [[ "$INTEGRATION_BUILD" == 1 ]]; then
echo 'Integration build: Pulling transifex translations.'
  rake tx:pull tx:wagon:pull tx:push tx:wagon:push -t
fi

BUILD_DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "(built at: $BUILD_DATE)" > BUILD_INFO
