#!/bin/bash

if ! which jazzy >/dev/null; then
  echo "Jazzy not detected: You can download it from https://github.com/realm/jazzy"
  exit
fi

jazzy \
  --clean \
  --author Zeeshan Mian \
  --author_url https://zmian.me \
  --github_url https://github.com/zmian/xcore.swift \
  --github-file-prefix https://github.com/zmian/xcore.swift/blob/master \
  --module-version 1.0.0 \
  --xcodebuild-arguments -scheme, Xcore \
  --module Xcore \
  --root-url https://github.com/zmian/xcore.swift\
  -x -workspace,Xcore.xcworkspace,-scheme,Xcore
