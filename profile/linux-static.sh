#!/usr/bin/env bash

function main {
    src_path=${1:-/workdir/src}
    build_path=${2:-/workdir/build}
    prefix_path=${3:-/workdir/install}

    git clone --depth 1 https://github.com/ZLMediaKit/ZLMediaKit.git "${src_path}"
    git -C "${src_path}" submodule update --init

    cmake -B"${build_path}" "${src_path}" \
        -DCMAKE_INSTALL_PREFIX="${prefix_path}" \
        -DENABLE_WEBRTC:BOOL="0" \
        -DENABLE_SRT:BOOL="1" \
        -DCMAKE_EXE_LINKER_FLAGS:STRING="-static" \
        -DENABLE_FFMPEG:BOOL="1" \
        -DENABLE_PLAYER:BOOL="1" \
        -DENABLE_RTPPROXY:BOOL="0" \
        -DCMAKE_BUILD_TYPE:STRING="Release" 

    cd "${build_path}" || exit
    make "-j$(nproc)"
    make install
    echo "done"
}

main "$@"