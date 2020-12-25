
Pod::Spec.new do |s|
  s.name         = "RNZoomUs"
  s.version      = "2.0.0"
  s.summary      = "RNZoomUs"
  s.description  = <<-DESC
                  React Native integration for Zoom SDK
                   DESC
  s.homepage     = "https://github.com/phu2810/react-native-zoom-us.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "phunv" }
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/phu2810/react-native-zoom-us.git" }
  s.source_files  = "ios/*", "ios/src/**/*"
  s.prefix_header_contents = "#import <Foundation/Foundation.h>"
  s.prefix_header_contents = "#import <MobileRTC/MobileRTC.h>"
  s.requires_arc = false

  s.libraries = "sqlite3", "z.1.2.5", "c++"

  s.dependency "React"
  s.dependency "ZoomSDK_iOS", '5.2.42037.1113'  
end

