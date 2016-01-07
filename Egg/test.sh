#!/bin/sh

bundle_path=vendor/bundle

if [ -e $bundle_path ]; then
    xcodebuild test -project Egg.xcodeproj -scheme Egg -destination 'platform=iOS Simulator,OS=9.2,name=iPad 2' | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}
else
    xcodebuild test -project Egg.xcodeproj -scheme Egg -destination 'platform=iOS Simulator,OS=9.2,name=iPad 2' 
fi