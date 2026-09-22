#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
set -euo pipefail
KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
NDK_DIR="${ANDROID_HOME:?Set ANDROID_HOME}/ndk/27.1.12297006"
TOOLCHAIN_DIR="$NDK_DIR/toolchains/llvm/prebuilt/darwin-x86_64/bin"
ABI="${1:-arm64-v8a}"
case "$ABI" in
 arm64-v8a) ARCH=aarch64; CPU=armv8-a; TRIPLE=aarch64-linux-android ;;
 armeabi-v7a) ARCH=arm; CPU=armv7-a; TRIPLE=armv7a-linux-androideabi ;;
 *) echo "Unsupported ABI: $ABI" >&2; exit 1 ;;
esac
cd "$KIT_DIR/ffmpeg-9.0.1"
if [ -f ffbuild/config.mak ]; then make distclean; fi
./configure --target-os=android --enable-cross-compile --arch="$ARCH" --cpu="$CPU" \
  --cc="$TOOLCHAIN_DIR/${TRIPLE}24-clang" \
  --cxx="$TOOLCHAIN_DIR/${TRIPLE}24-clang++" \
  --nm="$TOOLCHAIN_DIR/llvm-nm" --ar="$TOOLCHAIN_DIR/llvm-ar" \
  --ranlib="$TOOLCHAIN_DIR/llvm-ranlib" --strip="$TOOLCHAIN_DIR/llvm-strip" \
  --libdir="android-libs/$ABI" --enable-static --disable-shared --enable-pic \
  --disable-doc --disable-programs --disable-everything --disable-avdevice --disable-avformat \
  --disable-swscale --disable-avfilter --disable-symver --enable-swresample \
  --disable-v4l2-m2m --disable-vulkan --disable-network --disable-autodetect \
  --enable-decoder=ac3 --enable-decoder=eac3 --enable-decoder=dca --enable-decoder=truehd \
  --enable-decoder=mlp --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=mp3 \
  --enable-decoder=mp2 --enable-decoder=flac --enable-decoder=vorbis --enable-decoder=opus
make -j8
make install-libs
