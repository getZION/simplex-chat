.PHONY: clean all

all: build

clean:
	rm -rf ./apps/ios/Libraries/mac ./apps/ios/Libraries/ios ./apps/ios/Libraries/sim

prepare:
	./scripts/ios/mac2ios.sh

create_directories:
	mkdir -p ./apps/ios/Libraries/mac ./apps/ios/Libraries/ios ./apps/ios/Libraries/sim

build_lib:
	sh ./scripts/desktop/build-lib-mac.sh

copy_files:
	cp -r dist-newstyle/build/aarch64-osx/ghc-9.6.3/simplex-chat-5.4.2.1/build/* ./apps/ios/Libraries/mac
	chmod +w ./apps/ios/Libraries/mac/*

copy_ios_sim_files:
	cp ./apps/ios/Libraries/mac/* ./apps/ios/Libraries/ios
	cp ./apps/ios/Libraries/mac/* ./apps/ios/Libraries/sim

convert_binaries:
	for f in ./apps/ios/Libraries/ios/*; do echo "file $$f"; done
	for f in ./apps/ios/Libraries/ios/*; do ./bin/mac2ios $$f; done
	for f in ./apps/ios/Libraries/sim/*; do ./bin/mac2ios -s $$f; done

build: clean create_directories copy_files grant_permissions copy_ios_sim_files convert_binaries
