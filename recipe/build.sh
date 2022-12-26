if [ "$target_platform" = "osx-arm64" ] && [ "$CONDA_BUILD_CROSS_COMPILATION" = "1" ] ; then
  export V8_FROM_SOURCE=1
fi

maturin build --release --strip --manylinux off --interpreter="${PYTHON}"
"${PYTHON}" -m pip install $SRC_DIR/target/wheels/vl_convert_python*.whl --no-deps -vv
