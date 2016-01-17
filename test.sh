#!/bin/sh

cd iOS
xcodebuild test -workspace agent-ios.xcworkspace -scheme agent-ios \
-destination 'platform=iOS Simulator,OS=9.2,name=iPad 2' | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}

cd ../
cd libs/Egg
xcodebuild test -project Egg.xcodeproj -scheme Egg -destination 'platform=iOS Simulator,OS=9.2,name=iPad 2' | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}

cd ../
cd libs/RoutesCompiler
xcodebuild test -project RoutesCompiler.xcodeproj -scheme RoutesCompiler -destination 'platform=iOS Simulator,OS=9.2,name=iPad 2' | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}
