//
//  AppDelegate.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 3/17/14.
//  Copyright (c) 2014 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
* We recommend that, you can generate jwttoken on your own server instead of hardcore in the code.
* We hardcore it here, just to run the demo.
*
* You can generate a jwttoken on the https://jwt.io/
* with this payload:
* {
*     "appKey": "string", // app key
*     "iat": long, // access token issue timestamp
*     "exp": long, // access token expire time
*     "tokenExp": long // token expire time
* }
*/
// Phunv: Xoa define constant domain o day chuyen vao init
//#define KjwtToken    @""
//// Phunv: Can phai sua o day moi chay dc!!! => ko de domain rong
//#define kSDKDomain   @"zoom.us"

// Phunv: Refactor het AppDelegate -> RNZoomAppDelegate
@interface RNZoomAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, MobileRTCPremeetingDelegate>

@property (strong, nonatomic) UIWindow *window;

- (UIViewController *)topViewController;
@end
