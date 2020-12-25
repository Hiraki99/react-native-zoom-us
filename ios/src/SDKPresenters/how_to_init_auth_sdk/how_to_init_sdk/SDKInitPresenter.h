//
//  SDKInitPresenter.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/19.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Phunv: be tu appdelegate sang day
#define KjwtToken    @""
// Phunv: Can phai sua o day moi chay dc!!! => ko de domain rong
#define kSDKDomain   @"zoom.us"

@interface SDKInitPresenter : NSObject

- (void)SDKInit:(UINavigationController *)navVC;

@end
