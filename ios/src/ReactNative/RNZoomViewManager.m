//
//  OGWaveManager.m
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 10/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RNZoomViewManager.h"
#import <React/UIView+React.h>
#import "RNZoomView.h"

@implementation RNZoomViewManager

- (UIView *)view
{
    RNZoomView *rnZoomView = [[RNZoomView alloc] init];
    [rnZoomView setZoomInfo:@{
        @"roomNumber": @"75525947059",
        @"roomPassword": @"F0b9ev",
        @"userDisplayName": @"Phu2",
        @"userPassword": @"123",
    }];
    return rnZoomView;
}
RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
