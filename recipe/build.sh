## Set conda CC as custom CC in Rust
#export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=$CC
#export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=$CC
#export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=$CC

echo Original target is $TARGET

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

  maturin build --release --target aarch64-apple-darwin --strip --manylinux off --interpreter="${PYTHON}"
else
  maturin build --release --strip --manylinux off --interpreter="${PYTHON}"
fi

"${PYTHON}" -m pip install $SRC_DIR/target/wheels/vl_convert_python*.whl --no-deps -vv
