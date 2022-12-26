declare -a _xtra_maturin_args

if [ "$target_platform" = "osx-arm64" ] && [ "$CONDA_BUILD_CROSS_COMPILATION" = "1" ] ; then

      mkdir $SRC_DIR/.cargo
      cat <<EOF >> $SRC_DIR/.cargo/config
# Required for intermediate codegen stuff
[target.x86_64-apple-darwin]
linker = "$CC_FOR_BUILD"
# Required for final binary artifacts for target
[target.aarch64-apple-darwin]
linker = "$CC"
rustflags = [
  "-C", "link-arg=-undefined",
  "-C", "link-arg=dynamic_lookup",
]

EOF

  _xtra_maturin_args+=(--target=aarch64-apple-darwin)

  # This variable must be set to the directory containing the target's libpython DSO
  export PYO3_CROSS_LIB_DIR=$PREFIX/lib

  # xref: https://github.com/PyO3/pyo3/commit/7beb2720
  export PYO3_PYTHON_VERSION=${PY_VER}
fi

maturin build --release --strip --manylinux off "${_xtra_maturin_args[@]}"

python -m pip install $SRC_DIR/target/wheels/vl_convert_python*.whl --no-deps -vv
