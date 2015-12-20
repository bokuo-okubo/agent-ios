#!/bin/sh

project_name=agent-ios
bundle_path=vendor/bundle

separator() {
    echo "-------------"
}

invoke() {
    echo "$1"
    eval "$1" || exit
    separator
}

## is exist swiftlint
if ! which swiftlint >/dev/null; then
    echo "SwiftLint does not exist, download from https://github.com/realm/SwiftLint"
    separator
else
    echo "SwiftLint already exists! You can use linter!"
    separator
fi

## install gem cocoapods
if [ ! -e $bundle_path ]; then
    invoke "bundle install --path vendor/bundle -j4"
fi

## install pods
invoke "bundle exec pod install"
invoke "open $project_name.xcworkspace/"
