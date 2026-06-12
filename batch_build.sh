#!/bin/bash

set -ex;

org='vda-linux'
proj='busybox_mirror'
version_num=10

build() {
    local version=$1
    ./build_on_host.sh $version
}

batch_build() {
    local versions_=$(./versions.sh $version_num)

    for version_ in $versions_; do
        build $version_
    done
}

upload () {
    local version=$1
    gh release create ${version} \
        --title "Release ${vesion}" \
        --notes "Automated build for version ${version} based on ${org}/${proj}" \
        dists/${proj}-${version}/*
}

batch_upload() { 
    local versions_=$(./versions.sh $version_num)

    for version_ in $versions_; do
        gh release view ${version_} > /dev/null 2>&1 || upload $version_
    done
}

batch_upload
