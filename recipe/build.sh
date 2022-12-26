declare -a _xtra_maturin_args

if [ "$target_platform" = "osx-arm64" ] && [ "$CONDA_BUILD_CROSS_COMPILATION" = "1" ] ; then
  _xtra_maturin_args+=(--target=aarch64-apple-darwin)
fi

maturin build --release --strip --manylinux off --interpreter="${PYTHON}" "${_xtra_maturin_args[@]}"

"${PYTHON}" -m pip install $SRC_DIR/target/wheels/vl_convert_python*.whl --no-deps -vv
