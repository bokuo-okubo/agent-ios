#!/bin/sh

xcodebuild test -workspace agent-ios.xcworkspace -scheme agent-ios \
-destination 'platform=iOS Simulator,OS=9.2,name=iPad 2' | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}
