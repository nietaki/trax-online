#!/bin/bash

set -x

ROOT_DIR=`dirname "$0"`

pushd $ROOT_DIR
mix deps.get
mix compile
popd

rm -rf $ROOT_DIR/apps/trax_web/assets/elm/elm-stuff/

pushd $ROOT_DIR/apps/trax_web/assets/
npm install
# this might spit out all sorts of errors the first time it's run
# the second time around it should be OK
node node_modules/.bin/brunch build
node node_modules/.bin/brunch build
popd
