SCHEME_NAME := "Example"
WORKSPACE_NAME := Xcore.xcworkspace
TEST_DESTINATION := platform="iOS Simulator,name=iPhone 15 Pro,OS=16.0"

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

docC-disabled:
	swift package \
		--allow-writing-to-directory /docs-out/ \
		generate-documentation \
		--target Xcore \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path /xcore/ \
		--output-path /docs-out/

docs-disabled:
	xcodebuild docbuild \
		-workspace Xcore.xcworkspace \
		-scheme Xcore \
		-destination generic/platform=iOS \
		OTHER_DOCC_FLAGS="--disable-indexing --transform-for-static-hosting --hosting-base-path /xcore/ --output-path /docs-out/"
