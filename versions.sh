#!/usr/bin/bash

number=${1:-10}

versions(){
    curl -sL https://api.github.com/repos/vda-linux/busybox_mirror/git/matching-refs/tags | \
        jq -r '.[].ref' | \
        sort -rV | \
        head -n ${number} | \
        sed 's:refs/tags/::g'
}

versions
