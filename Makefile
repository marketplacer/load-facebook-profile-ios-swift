default: test

clean:
	@echo "\n\033[04m+ clean\033[0m"
	rm -rf ~/Library/Developer/Xcode/DerivedData/LoadFacebookProfile-*/Build
	rm -rf bin
	rm -rf build

clean-module-cache:
	@echo "\n\033[04m+ clean module cache\033[0m"
	rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache

carthage-update:
	carthage update --platform iOS

test: 
	xcodebuild -scheme LoadFacebookProfileKit -project LoadFacebookProfile.xcodeproj -destination "platform=iOS Simulator,name=iPhone Retina (4-inch 64-bit)" clean build test

test-ci: clean test

test-ui:
	xcodebuild -scheme "LoadFacebookProfile" -project LoadFacebookProfile.xcodeproj -destination "platform=iOS Simulator,name=iPhone Retina (4-inch 64-bit)" clean build test

test-ui-ci: clean test-ui
