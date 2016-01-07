# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift

use_frameworks!

def main_pods
  pod 'Realm' ## client data store library
  pod 'Dollar' ## extend swift like lodash.js
end

def testing_pods
  pod 'Realm/Headers'
  pod 'Quick', '~> 0.8.0'
  pod 'Nimble', '3.0.0'
end

target 'agent-ios' do main_pods end;
target 'agent-iosTests' do testing_pods end;
# target 'agent-iosUITests' do testing_pods end;
