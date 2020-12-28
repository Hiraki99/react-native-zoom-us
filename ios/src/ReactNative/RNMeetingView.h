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

@property (nonatomic, strong) NSString *userID;
@property (strong, nonatomic) MobileRTCActiveVideoView * activeVideoView;

@property (strong, nonatomic) MobileRTCPreviewVideoView  * preVideoView;
@property (strong, nonatomic) MobileRTCVideoView *videoView;

- (void) handleEventPreviewStopped;

@end

NS_ASSUME_NONNULL_END
