FROM golang:alpine

RUN apk add --no-cache build-base cmake ninja zip unzip curl git pkgconfig perl nasm

ENV VCPKG_FORCE_SYSTEM_BINARIES=1
ENV CC=/usr/bin/gcc CXX=/usr/bin/g++
ENV CXXFLAGS="-Wno-error=maybe-uninitialized"
ENV SHELL=/bin/sh

WORKDIR /root

RUN wget https://raw.githubusercontent.com/disgoorg/godave/refs/heads/master/scripts/libdave_install.sh
RUN chmod +x libdave_install.sh
RUN FORCE_BUILD=1 ./libdave_install.sh v1.1.0

ENV PKG_CONFIG_PATH="/root/.local/lib/pkgconfig"
