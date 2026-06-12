#!/bin/bash
set -exuo pipefail

readonly version="$1"

readonly org='vda-linux'
readonly proj='busybox_mirror'
readonly arch='loongarch64'
readonly goarch='loong64'
readonly proj_name="${proj}-${version}"

# 映射目录
readonly workspace="/workspace"
readonly dists="${workspace}/dists"
readonly patches="${workspace}/patches"

readonly build="/build"
readonly source_root="${build}/${proj_name}"
readonly build_root="${build}/${proj_name}"
readonly package_root="${dists}/${proj_name}"

mkdir -p "${build}"


apply_patches()
{
    for patch_ in ${patches}/*.patch;
    do
        git apply ${patch_}
    done
}

fetch_source_code()
{
    rm -rf "${source_root}"
    git clone --branch "${version}" --depth=1 "https://github.com/${org}/${proj}" "${source_root}"
}

build(){
    pushd "${build_root}"
        make defconfig
        sed -i 's:CONFIG_TC=y:# CONFIG_TC is not set:g' .config
        sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
        sed -i 's:CONFIG_SHA1_HWACCEL=y:# CONFIG_SHA1_HWACCEL is not set:g' .config
        make -j`nproc`
        make install
    popd
}

package(){
    rm -rf "${package_root}"
    mkdir -p "${package_root}"
    pushd "${package_root}"
        cp -a ${build_root}/_install ./busybox-loongarch64-${version}
        tar czf busybox-loongarch64-${version}.tar.gz ./busybox-loongarch64-${version}
        rm -rf ./busybox-loongarch64-${version}
    popd

}

main()
{
    fetch_source_code
    build
    package
}

main "$@"
