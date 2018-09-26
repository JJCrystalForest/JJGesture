Pod::Spec.new do |s|
s.name         = "JJGesture"
s.version      = "1.0.0"
s.summary      = "a gesture password control."
s.description  = "a gesture password control."
s.homepage     = "https://github.com/JJCrystalForest/JJGesture"
s.social_media_url   = "https://github.com/JJCrystalForest"
s.license= { :type => "MIT", :file => "LICENSE" }
s.author       = { "little_forest" => "13702727599@163.com" }
s.source       = { :git => "https://github.com/JJCrystalForest/JJGesture.git", :tag => "1.0.0" }
s.source_files = "JJGesture/JJGesture/Gesture/**/*.swift"
s.ios.deployment_target = '8.0'
s.frameworks   = 'UIKit'
s.requires_arc = true
s.swift_version = '4.2'

end

