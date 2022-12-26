## Set conda CC as custom CC in Rust
#export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=$CC
#export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=$CC
#export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=$CC

maturin build --release --strip --manylinux off --interpreter="${PYTHON}"
"${PYTHON}" -m pip install $SRC_DIR/target/wheels/vl_convert_python*.whl --no-deps -vv
