//
//  WrapperView.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/UIView+React.h>
#import <React/RCTResizeMode.h>

NS_ASSUME_NONNULL_BEGIN

@class RNMeetingView;

@interface RNZoomView : UIView

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *type;
@property (strong, nonatomic) RNMeetingView *rnMeetingView;
@property (strong, nonatomic) UIImageView *captureImage;

@end

NS_ASSUME_NONNULL_END
