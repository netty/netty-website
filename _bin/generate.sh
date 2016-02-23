#!/bin/bash -e

cd "`dirname "$0"`/.." && bundle exec awestruct --generate --url=http://netty.io "$@"

