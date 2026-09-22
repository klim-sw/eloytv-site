#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
set -euo pipefail
cd "$(dirname "$0")"
: "${ANDROID_HOME:?Set ANDROID_HOME to your Android SDK}"
if [ ! -d ffmpeg-9.0.1 ]; then tar -xf ffmpeg-9.0.1.tar.xz; fi
for abi in arm64-v8a armeabi-v7a; do
  bash build-ffmpeg.sh "$abi"
  "$ANDROID_HOME/cmake/3.22.1/bin/cmake" -S jni -B "build/$abi" -G Ninja \
    -DCMAKE_MAKE_PROGRAM="$ANDROID_HOME/cmake/3.22.1/bin/ninja" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_HOME/ndk/27.1.12297006/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$abi" -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release -DFFMPEG_PATH="$PWD/ffmpeg-9.0.1"
  "$ANDROID_HOME/cmake/3.22.1/bin/cmake" --build "build/$abi"
  mkdir -p "output/$abi"
  cp "build/$abi/libffmpegJNI.so" "output/$abi/"
done
