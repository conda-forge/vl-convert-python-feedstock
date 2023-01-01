## Set conda CC as custom CC in Rust
#export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=$CC
#export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=$CC
#export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=$CC

echo Original target is $TARGET

if [ "$target_platform" = "osx-arm64" ] && [ "$CONDA_BUILD_CROSS_COMPILATION" = "1" ] ; then
  # Manually override TARGET, which rusty_v8 uses to determine which share libraries to
  # link against
  export TARGET="aarch64-apple-darwin"
  maturin build --release --target aarch64-apple-darwin --strip --manylinux off --interpreter="${PYTHON}"
else
  maturin build --release --strip --manylinux off --interpreter="${PYTHON}"
fi

"${PYTHON}" -m pip install $SRC_DIR/target/wheels/vl_convert_python*.whl --no-deps -vv
