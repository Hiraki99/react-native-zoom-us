//
//  JoinMeetingUtils.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RNZoomView;

@interface RNMeetingCenter : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) RNZoomView *currentZoomView;

- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rnZoomView:(id) rnZoomView;
- (void) leaveCurrentMeeting;
- (void) checkPendingJoinMeetingAfterAuth;
- (BOOL) isEnableRNMeetingView;
@end

NS_ASSUME_NONNULL_END
