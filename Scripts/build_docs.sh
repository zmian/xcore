#!/bin/zsh

swift package \
    --allow-writing-to-directory ./docs \
    generate-documentation \
    --target Xcore \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path Xcore \
    --output-path ./docs
