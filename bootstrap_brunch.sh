#!/bin/bash

set -x

ROOT_DIR=`dirname "$0"`

pushd $ROOT_DIR/apps/trax_web/assets/
npm install
popd

# this will probably spit out all sorts of error the first time it's run
# the second time around it should be OK
mix phx.server

