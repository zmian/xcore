#!/bin/sh

set -e

# Skip SwiftLint if explicitly asked for using env var
if [ "$SKIP_BUILD_PHASE_SWIFTLINT" == "YES" ]; then
    echo "⏭ Skipping SwiftLint build phase."
    exit 0
fi

# Run lint for application.

# Adds support for Apple Silicon brew directory.
export PATH="$PATH:/opt/homebrew/bin"

# If SwiftLint isn't installed then exit early.
if ! which swiftlint >/dev/null; then
    echo "
    error: 🛑 SwiftLint is not installed, Run 'brew install swiftlint'
    "
    exit 1
fi

# SwiftLint should have minimum version
currentver="$(swiftlint version)"
minrequiredver="0.53.0"

if [ "$(printf '%s\n' "$minrequiredver" "$currentver" | sort -V | head -n1)" = "$minrequiredver" ]; then
    swiftlint lint
else
    echo "
    error: 🛑 Your SwiftLint version $currentver is outdated.
    Requires at least version $minrequiredver, Run 'brew upgrade swiftlint'
    "
    exit 1
fi
