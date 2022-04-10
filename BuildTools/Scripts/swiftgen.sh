#!/bin/sh

set -e

# Skip SwiftGen if explicitly asked for using env var
if [ "$SKIP_BUILD_PHASE_SWIFTGEN" == "YES" ]; then
    echo "⏭ Skipping SwiftGen build phase."
    exit 0
fi

# Generates strings for application.

# Adds support for Apple Silicon brew directory.
export PATH="$PATH:/opt/homebrew/bin"

# If SwiftGen isn't installed then exit early.
if ! which swiftgen >/dev/null; then
    echo "
    error: 🛑 SwiftGen is not installed, Run 'brew install swiftgen' in your terminal.
    "
    exit 1
fi

# SwiftGen should have minimum version
currentver="$(swiftgen --version)"
minrequiredver="SwiftGen v6.4.0 (Stencil v0.13.1, StencilSwiftKit v2.7.2, SwiftGenKit v6.4.0)"

if [ "$(printf '%s\n' "$minrequiredver" "$currentver" | sort -V | head -n1)" = "$minrequiredver" ]; then
    cd ../ && swiftgen
else
    echo "
    error: 🛑 Your SwiftGen version $currentver is outdated.
    Requires at least version $minrequiredver, Run 'brew upgrade swiftgen' in your terminal.
    "
    exit 1
fi
