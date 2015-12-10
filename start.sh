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

## install gem cocoapods
if [ ! -e $bundle_path ]; then
    invoke "bundle install --path vendor/bundle"
fi

## install pods
invoke "bundle exec pod install"
invoke "open $project_name.xcworkspace/"
