#!/usr/bin/env bash
set -ex

if [ -f *.whl ]; then
    # arm64 / aarch64: install pre-built wheel
    cp vl_convert_python*/licenses/LICENSE .
    ${PYTHON} -m pip install *.whl -vv
else
    # Source build (linux_64, osx_64)
    export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
    export AWS_LC_SYS_CMAKE_BUILDER=1

    if [ "$(uname)" = "Linux" ]; then
        # Download pre-built V8 compiled with -fPIC for shared library compatibility.
        # The standard rusty_v8 prebuilt uses Initial Exec TLS model which is
        # incompatible with Python extension modules loaded via dlopen().
        V8_VERSION=$(cargo metadata --format-version 1 | jq -r '.packages[] | select(.name == "v8") | .version')
        curl -L -o "${SRC_DIR}/librusty_v8.a" \
            "https://github.com/vega/vl-convert/releases/download/v8-${V8_VERSION}/librusty_v8-linux-x86_64.a"
        export RUSTY_V8_ARCHIVE="${SRC_DIR}/librusty_v8.a"
    fi

    ${PYTHON} -m pip install . -vv
fi
