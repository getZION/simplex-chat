# Makefile for building an Xcode project

# Define the scheme and configuration
SCHEME = "SimpleX (iOS)"
CONFIGURATION = Debug

# Define the default make target
all: build

# Target to build the project
build:
	xcodebuild -scheme $(SCHEME) -configuration $(CONFIGURATION) -destination 'platform=iOS Simulator' CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO" build

# Target to clean the build
clean:
	xcodebuild -scheme $(SCHEME) -configuration $(CONFIGURATION) clean

# Additional targets can be added as needed
