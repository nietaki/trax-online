#!/bin/bash

set -x

ROOT_DIR=`dirname "$0"`

pushd $ROOT_DIR
mix deps.get
mix compile
popd

pushd $ROOT_DIR/apps/trax_web/assets/
npm install
# this will probably spit out all sorts of error the first time it's run
# the second time around it should be OK
node node_modules/.bin/brunch build
node node_modules/.bin/brunch build
popd

pushd $ROOT_DIR
mix phx.server
