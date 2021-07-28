#!/bin/sh

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
minrequiredver="0.43.1"

if [ "$(printf '%s\n' "$minrequiredver" "$currentver" | sort -V | head -n1)" = "$minrequiredver" ]; then
    swiftlint lint
else
    echo "
    error: 🛑 Your SwiftLint version $currentver is outdated.
    Requires at least version $minrequiredver, Run 'brew upgrade swiftlint'
    "
    exit 1
fi
