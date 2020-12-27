
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <MobileRTC/MobileRTC.h>
#import <React/RCTViewManager.h>

@interface RNZoomUs : RCTViewManager
@end


//@interface RNZoomUs : NSObject <RCTBridgeModule, MobileRTCAuthDelegate, MobileRTCMeetingServiceDthinhelegate>
