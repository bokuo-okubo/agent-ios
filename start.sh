#!/bin/sh

project_name=agent-ios

separator() {
    echo "-------------"
}

invoke() {
    echo "$1"
    eval "$1"
    separator
}

## install gem cocoapods
invoke "bundle install --path vendor/bundle"

## install pods
invoke "bundle exec pod install"
invoke "open $project_name.xcworkspace/"
