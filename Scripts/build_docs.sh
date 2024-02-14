#!/bin/zsh

# swift package \
#     --allow-writing-to-directory ./docs \
#     generate-documentation \
#     --target Xcore \
#     --disable-indexing \
#     --transform-for-static-hosting \
#     --hosting-base-path Xcore \
#     --output-path ./docs

# TODO: Finish setting up DocC
# https://maxxfrazer.medium.com/deploying-docc-with-github-actions-218c5ca6cad5
# https://medium.com/kinandcartacreated/host-and-automate-your-docc-documentation-c6ac29dc0feb
xcodebuild docbuild \
    -derivedDataPath docc \
    -workspace Xcore.xcworkspace \
    -scheme Xcore \
    -destination 'generic/platform=iOS' \
    -parallelizeTargets
