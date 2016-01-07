Pod::Spec.new do |s|

  s.name         = "Egg"
  s.version      = "0.0.2"
  s.summary      = "A Swift Tokenizer Library"

  s.description  = <<-DESC
  "A Swift Tokenizer Library"
  DESC

  s.homepage     = "https://github.com/bokuo-okubo/Egg"
  s.license      = "MIT"
  s.author             = { "BKO" => "okubo.yohei@gmail.com" }

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"
  #  When using multiple platforms
  s.ios.deployment_target = "8.1"

  s.source       = { :git => "https://github.com/bokuo-okubo/Egg.git" }

  s.source_files  = "Sources/**/*"
  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
end
