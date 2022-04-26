#!/usr/bin/env bash

set -eo pipefail

if [[ "$INTEGRATION_BUILD" == 1 ]]; then
  echo 'Integration build: Updating composition wagons to their HEADs.'
  git submodule update --remote
fi

# record the deployed versions from git before nuking the repo
git submodule status | tee WAGON_VERSIONS

# move core
rm -r hitobito/.git
mv hitobito/* .

# add wagon sources
mkdir -p vendor/wagons
for dir in hitobito_*; do
  if [[ ( -d $dir ) ]]; then
    rm -r $dir/.git
    mv $dir vendor/wagons/
  fi
done

# move hidden core dirs
mv hitobito/.tx .

# place Wagonfile
cp /opt/shared/Wagonfile .

# finally remove core source directory
rm -rf hitobito
rm -r .git
