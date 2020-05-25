#!/bin/bash
#
# Copyright (c) 2019 Ant Financial
#
# SPDX-License-Identifier: Apache-2.0

set -e

[ -n "${KATA_DEV_MODE:-}" ] && exit 0

cidir=$(dirname "$0")
source "${cidir}/lib.sh"

rustarch=$(${cidir}/kata-arch.sh --rust)
# release="nightly"
# recent functional version
version="${1:-""}"
if [ -z "${version}" ]; then
	version=$(get_version "languages.rust.version")
fi

if ! command -v rustup > /dev/null; then
	curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

export PATH="${PATH}:${HOME}/.cargo/bin"

rustup default ${version}
rustup toolchain install ${version}-musl
rustup target add ${rustarch}-unknown-linux-musl
rustup component add rustfmt
sudo ln -sf /usr/bin/g++ /bin/musl-g++
