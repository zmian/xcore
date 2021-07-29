SCHEME_NAME := "Example"
WORKSPACE_NAME := Xcore.xcworkspace
TEST_DESTINATION := platform="iOS Simulator,name=iPhone 12 Pro,OS=15.0"

default: test

test:
	@xcodebuild test \
		-allowProvisioningUpdates \
		-configuration "Debug" \
		-workspace $(WORKSPACE_NAME) \
		-scheme $(SCHEME_NAME) \
		-destination $(TEST_DESTINATION) \
		| xcpretty

format:
	@swiftformat .

lint:
	@swiftlint lint
