//
//  RNMeetingView.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNMeetingView : UIView

@property (strong, nonatomic) MobileRTCActiveVideoView * videoView;
@property (strong, nonatomic) MobileRTCPreviewVideoView  * preVideoView;

@end

NS_ASSUME_NONNULL_END
