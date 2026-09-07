#!/usr/bin/env bash
set -ex

export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
export AWS_LC_SYS_CMAKE_BUILDER=1

${PYTHON} -m pip install . -vv
