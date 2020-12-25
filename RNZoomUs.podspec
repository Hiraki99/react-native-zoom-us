
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

  s.requires_arc = false

  s.libraries = "sqlite3", "z.1.2.5", "c++"

  s.dependency "React"
  s.dependency "ZoomSDK_iOS", '5.2.42037.1113'  

  s.prefix_header_contents = "
#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTC.h>

//for iOS version check
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IsIphoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

//for device check
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define RGBCOLOR(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define BUTTON_FONT [UIFont fontWithName:@\"HelveticaNeue-Bold\" size:18.0]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SAFE_ZOOM_INSETS  34

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define Width(v)                CGRectGetWidth((v).frame)
#define Height(v)               CGRectGetHeight((v).frame)

#define MinX(v)            CGRectGetMinX((v).frame)
#define MinY(v)            CGRectGetMinY((v).frame)

#define MidX(v)            CGRectGetMidX((v).frame)
#define MidY(v)            CGRectGetMidY((v).frame)

#define MaxX(v)            CGRectGetMaxX((v).frame)
#define MaxY(v)            CGRectGetMaxY((v).frame)

#define RGBCOLOR(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
  "
end

