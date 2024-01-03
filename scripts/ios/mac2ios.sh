#!/usr/bin/env sh
git clone https://github.com/zw3rk/mobile-core-tools.git
cd mobile-core-tools
make mac2ios

cd ..
mkdir -p bin
cp mobile-core-tools/mac2ios bin
rm -rf mobile-core-tools
