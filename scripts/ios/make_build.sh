#!/usr/bin/env sh

# clean
rm -rf ./apps/ios/Libraries/mac ./apps/ios/Libraries/ios ./apps/ios/Libraries/sim

# create directories
mkdir -p ./apps/ios/Libraries/mac ./apps/ios/Libraries/ios ./apps/ios/Libraries/sim

# TODO: build script

# copy files
cp -r dist-newstyle/build/aarch64-osx/ghc-9.6.3/simplex-chat-5.4.2.1/build/* ./apps/ios/Libraries/mac

# grant write permission
chmod +w ./apps/ios/Libraries/mac/*

# copy files
cp ./apps/ios/Libraries/mac/* ./apps/ios/Libraries/ios
cp ./apps/ios/Libraries/mac/* ./apps/ios/Libraries/sim

# convert mac binaries to ios binaries
for f in ./apps/ios/Libraries/ios/*; do mac2ios $f; done | wc -l
for f in ./apps/ios/Libraries/sim/*; do mac2ios -s $f; done | wc -l
