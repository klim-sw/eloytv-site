# EloyTV FFmpeg audio source and relinking kit

Applies to EloyTV Android beta 0.1.2 (versionCode 3). FFmpeg 9.0.1 is
unmodified upstream source. Its archive SHA-256 is
`cf38e0e28c7e5605942c4a77755349b0145804a397af37eb1fb4c77cb237f635`.
Every upstream file was compared against the source used for the release;
no changes or missing upstream files were found.

FFmpeg avcodec, avutil and swresample are statically linked into the shared
`libffmpegJNI.so`. The application loads this shared library. The accompanying
JNI C++ source and CMake project contain everything needed to relink it with a
modified FFmpeg. They derive from AndroidX Media3 / AOSP (Apache 2.0); original
copyright and licence headers are retained. The CMake adaptation uses
`-idirafter` to avoid VERSION shadowing libc++ headers and 16 KB ELF alignment.

## Build on macOS

Install Android SDK NDK 27.1.12297006 and CMake 3.22.1 using the Android SDK
manager, plus Apple's command line tools. Extract `eloytv-audio-source-0.1.2.tar.gz`
and place the supplied `ffmpeg-9.0.1.tar.xz` beside this README.

```
export ANDROID_HOME="$HOME/Library/Android/sdk"
bash rebuild.sh
```

The script builds both arm64-v8a and armeabi-v7a, API 24. It does not download
dependencies, require app signing secrets, or access an account. Source code
can be edited before rebuilding. The exact FFmpeg configure flags are in
`build-ffmpeg.sh`. GPL, nonfree, version3 and external autodetected libraries
are disabled. Outputs are `output/<ABI>/libffmpegJNI.so`.

## Use a modified library

Obtain your installed EloyTV APK(s) or the standalone beta APK supplied by the
developer. Replace `lib/<ABI>/libffmpegJNI.so` with the rebuilt library for each
ABI in the APK that contains it. Preserve the remaining application objects;
no proprietary application source is needed to relink the audio library.
Remove the old APK signature, zipalign with 16 KB support, and sign the APK(s)
with your own key using Android SDK zipalign/apksigner. All split APKs, when
used, must have the same new signature. Install on your own test device.

Android will not update the developer-signed installation with your signature.
Use a separate test device/profile, or export your data before replacing your
installation. The app does not add a signature check to prevent modified
FFmpeg libraries from running. We permit reverse engineering for debugging
modifications to the LGPL-covered library and replacement/relinking of that
library as allowed by LGPL 2.1 section 6. No developer private signing key is
required or included.

The source archive is available without charge or account. Corresponding
source and build help: klim.renew@gmail.com. Licence texts: COPYING.LGPLv2.1,
FFmpeg LICENSE.md (inside its source archive), and Apache-2.0.txt.
