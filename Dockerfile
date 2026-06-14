FROM golang:alpine3.20 AS build

RUN --mount=type=cache,target=/var/cache/apk \
    ln -s /var/cache/apk /etc/apk/cache && \
    apk add --no-cache build-base cmake ninja zip unzip curl git pkgconfig perl nasm ccache

ENV VCPKG_FORCE_SYSTEM_BINARIES=1
ENV CC=/usr/local/bin/gcc CXX=/usr/local/bin/g++
ENV CXXFLAGS="-Wno-error=maybe-uninitialized"
ENV SHELL=/bin/sh

RUN ln -s /usr/bin/ccache /usr/local/bin/gcc && ln -s /usr/bin/ccache /usr/local/bin/g++ && ln -s /usr/bin/ccache /usr/local/bin/cc && ln -s /usr/bin/ccache /usr/local/bin/c++
ENV CCACHE_DIR=/ccache

WORKDIR /root

COPY godave/scripts/libdave_install.sh ./
RUN chmod +x libdave_install.sh
RUN --mount=type=cache,target=/ccache \
    FORCE_BUILD=1 ./libdave_install.sh v1.1.0

ENV PKG_CONFIG_PATH="/root/.local/lib/pkgconfig"

FROM scratch
COPY --from=build /root/.local /root/.local
