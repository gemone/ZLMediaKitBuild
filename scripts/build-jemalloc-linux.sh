#!/usr/bin/env bash

[[ -e $(which git) ]] || exit

src_url="https://github.com/jemalloc/jemalloc.git"

function main {
    version=${1:-5.3.0}
    build_path=${2:-./build/jemalloc}
    static=${3:true}

    pwd=${PWD}

    git clone -b "${version}" ${src_url} "${build_path}"

    cd "${build_path}" || exit

    [[ -n ${static} ]] && sh "${build_path}/autogen.sh" --enable-static
    [[ -z ${static} ]] && sh "${build_path}/autogen.sh"

    make "-j$(nproc)"
    make install
    cd "${pwd}" || exit
    echo "done"
}

main "$@"
