# IOS Prepare Scripts

To build the iOS app, you will need to prepare some libraries beforehand. 

1. Take the `cabal.project.local` from the local directory.
2. Build the libs from source.
``` sh
./scripts/desktop/build-lib-mac.sh
```
3. Run the following script: 
`./scripts/ios/prepare_build.sh`


