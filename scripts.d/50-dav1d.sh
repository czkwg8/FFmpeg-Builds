#!/bin/bash

SCRIPT_REPO="https://code.videolan.org/videolan/dav1d.git"
SCRIPT_COMMIT="8d956180934f16244bdb58b39175824775125e55"

ffbuild_enabled() {
    [[ $ADDINS_STR == *4.2* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j$(nproc)
    ninja install
}

ffbuild_configure() {
    echo --enable-libdav1d
}

ffbuild_unconfigure() {
    [[ $ADDINS_STR == *4.2* ]] && return 0
    echo --disable-libdav1d
}
