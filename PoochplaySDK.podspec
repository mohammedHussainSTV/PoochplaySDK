Pod::Spec.new do |spec|

  spec.name         = "PoochplayBle-SDK"
  spec.version      = "1.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you perform calculation.
                   DESC

  spec.homepage     = "https://github.com/mohammedHussainSTV/PoochplaySDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "mohammedHussainSTV" => "mohammed.hussain@siya.tech" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/mohammedHussainSTV/PoochplaySDK.git", :tag => "#{spec.version}" }
  spec.source_files  = "Poochplay/**/*.{h,m,swift}"

end