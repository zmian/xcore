SHELL := /bin/bash
.DEFAULT_GOAL := help
.NOTPARALLEL:

XCODE_APP ?= $(if $(MD_APPLE_SDK_ROOT),$(MD_APPLE_SDK_ROOT),/Applications/Xcode.app)
DEVELOPER_DIR ?= $(XCODE_APP)/Contents/Developer
export DEVELOPER_DIR
export PATH := $(DEVELOPER_DIR)/usr/bin:$(DEVELOPER_DIR)/Platforms/iPhoneSimulator.platform/Developer/usr/bin:$(PATH)

WORKSPACE := Xcore.xcworkspace
SCHEME := Example
CONFIGURATION ?= Debug
DERIVED_DATA_PATH ?= $(CURDIR)/.build/DerivedData
APP_BUNDLE_ID ?= com.xcore.example
DOCC_OUTPUT_PATH ?= $(CURDIR)/.build/docc
DOCC_DERIVED_DATA_PATH ?= $(CURDIR)/.build/DocCDerivedData
DOCC_SYMBOL_GRAPH_PATH := $(DOCC_DERIVED_DATA_PATH)/Build/Intermediates.noindex/Xcore.build/$(CONFIGURATION)-iphoneos/Xcore.build/symbol-graph/swift/arm64-apple-ios
DOCC_FILTERED_SYMBOL_GRAPH_PATH := $(DOCC_DERIVED_DATA_PATH)/Build/FilteredSymbolGraphs

SIMULATOR_NAME ?= iPhone 17 Pro
SIMULATOR_OS ?= latest
SIMULATOR_DESTINATION ?= platform=iOS Simulator,name=$(SIMULATOR_NAME),OS=$(SIMULATOR_OS)
BUILD_DESTINATION ?= generic/platform=iOS Simulator
DOCC_DESTINATION ?= generic/platform=iOS
TEST_ONLY ?=

XCODEBUILD := xcodebuild
XCODEBUILD_FLAGS ?=
XCODEBUILD_BUILD_SETTINGS ?=
RAW_XCODEBUILD ?=
APP_PATH := $(DERIVED_DATA_PATH)/Build/Products/$(CONFIGURATION)-iphonesimulator/Example.app
XCODEBUILD_OUTPUT_FILTER := perl -ne 'next if /\[MT\] IDERunDestination: Supported platforms for the buildables in the current scheme is empty\.|\[MT\] IDETestOperationsObserverDebug:/; s/ on '\''[^'\'']+'\''// if /^(Test suite|Test case) /; print;'

ifneq ($(strip $(CI)),)
XCODEBUILD_FLAGS += -skipPackagePluginValidation -skipMacroValidation
XCODEBUILD_BUILD_SETTINGS += OTHER_SWIFT_FLAGS="\$$(inherited) -DCI"
RAW_XCODEBUILD := 1
export SIMCTL_CHILD_CI := true
endif

define xcodebuild_run
	@set -o pipefail; \
	if [ -n "$(RAW_XCODEBUILD)" ]; then \
		$(1); \
	elif command -v xcpretty >/dev/null 2>&1; then \
		$(1) 2>&1 | $(XCODEBUILD_OUTPUT_FILTER) | xcpretty; \
	elif command -v xcbeautify >/dev/null 2>&1; then \
		$(1) 2>&1 | $(XCODEBUILD_OUTPUT_FILTER) | xcbeautify; \
	else \
		$(1) 2>&1 | $(XCODEBUILD_OUTPUT_FILTER); \
	fi
endef

ifdef TEST_ONLY
ifneq ($(strip $(TEST_ONLY)),)
TEST_ONLY_ARG := -only-testing:$(TEST_ONLY)
endif
endif

.PHONY: help _ensure_xcode clean build build-docc tests test run lint format format-check

_ensure_xcode:
	@test -d "$(DEVELOPER_DIR)" || (echo "Xcode not found at $(DEVELOPER_DIR)" && exit 1)
	@xcodebuild -version >/dev/null
	@xcrun --find simctl >/dev/null

help: ## Show available targets
	@printf "Xcode app: %s\n" "$(XCODE_APP)"
	@printf "Scheme: %s\n" "$(SCHEME)"
	@printf "Simulator: %s\n\n" "$(SIMULATOR_DESTINATION)"
	@grep -E '^[a-zA-Z0-9_-]+:.*## ' $(MAKEFILE_LIST) | sed 's/:.*## /\t/'

clean: ## Remove local build and package state used by Make targets
	@rm -rf "$(DERIVED_DATA_PATH)" "$(CURDIR)/.build/workspace-state.json"

build: _ensure_xcode ## Build the example app and its framework dependencies
	$(call xcodebuild_run,$(XCODEBUILD) build $(XCODEBUILD_FLAGS) -workspace "$(WORKSPACE)" -scheme "$(SCHEME)" -configuration "$(CONFIGURATION)" -derivedDataPath "$(DERIVED_DATA_PATH)" -destination "$(BUILD_DESTINATION)" $(XCODEBUILD_BUILD_SETTINGS))

build-docc: _ensure_xcode ## Generate DocC static site output under DOCC_OUTPUT_PATH
	@rm -rf "$(DOCC_OUTPUT_PATH)" "$(DOCC_DERIVED_DATA_PATH)"
	$(call xcodebuild_run,$(XCODEBUILD) docbuild $(XCODEBUILD_FLAGS) -workspace "$(WORKSPACE)" -scheme Xcore -configuration "$(CONFIGURATION)" -derivedDataPath "$(DOCC_DERIVED_DATA_PATH)" -destination "$(DOCC_DESTINATION)" $(XCODEBUILD_BUILD_SETTINGS))
	@test -d "$(DOCC_SYMBOL_GRAPH_PATH)" || (echo "DocC symbol graphs not found at $(DOCC_SYMBOL_GRAPH_PATH)" && exit 1)
	@python3 BuildTools/Scripts/filter_docc_symbol_graphs.py "$(DOCC_SYMBOL_GRAPH_PATH)" "$(DOCC_FILTERED_SYMBOL_GRAPH_PATH)"
	@mkdir -p "$$(dirname "$(DOCC_OUTPUT_PATH)")"
	@xcrun docc convert \
		--additional-symbol-graph-dir "$(DOCC_FILTERED_SYMBOL_GRAPH_PATH)" \
		--fallback-display-name Xcore \
		--fallback-bundle-identifier com.zmian.xcore \
		--fallback-default-module-kind Framework \
		--output-path "$(DOCC_OUTPUT_PATH)" \
		--transform-for-static-hosting \
		--diagnostic-level error \
		--hosting-base-path "xcore$(if $(DOCC_VERSION),/$(DOCC_VERSION),)"

test: _ensure_xcode ## Run tests through the Example scheme
	@set -o pipefail; \
	$(XCODEBUILD) test -quiet $(XCODEBUILD_FLAGS) -workspace "$(WORKSPACE)" -scheme "$(SCHEME)" -configuration "$(CONFIGURATION)" -derivedDataPath "$(DERIVED_DATA_PATH)" -destination "$(SIMULATOR_DESTINATION)" $(TEST_ONLY_ARG) $(XCODEBUILD_BUILD_SETTINGS) 2>&1 | $(XCODEBUILD_OUTPUT_FILTER) && \
	echo "Tests passed"

run: _ensure_xcode ## Build, install, and launch the app in the configured simulator
	@xcrun simctl boot "$(SIMULATOR_NAME)" >/dev/null 2>&1 || true
	@xcrun simctl bootstatus "$(SIMULATOR_NAME)" -b
	$(call xcodebuild_run,$(XCODEBUILD) build $(XCODEBUILD_FLAGS) -workspace "$(WORKSPACE)" -scheme "$(SCHEME)" -configuration "$(CONFIGURATION)" -derivedDataPath "$(DERIVED_DATA_PATH)" -destination "$(SIMULATOR_DESTINATION)" $(XCODEBUILD_BUILD_SETTINGS))
	@test -d "$(APP_PATH)" || (echo "Built app not found at $(APP_PATH)" && exit 1)
	@open -a Simulator >/dev/null 2>&1 || true
	@xcrun simctl install booted "$(APP_PATH)"
	@xcrun simctl launch booted "$(APP_BUNDLE_ID)"

format: ## Run SwiftFormat
	@swiftformat .

format-check: ## Check SwiftFormat without changing files
	@swiftformat --lint .

lint: ## Run SwiftLint
	@swiftlint lint
