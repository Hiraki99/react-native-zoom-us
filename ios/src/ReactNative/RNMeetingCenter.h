//
//  JoinMeetingUtils.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNMeetingCenter : NSObject

+ (instancetype)shared;

- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rnZoomView:(id) rnZoomView;
- (void) leaveCurrentMeeting;
- (void) checkPendingJoinMeetingAfterAuth;
- (BOOL) isEnableRNMeetingView;
@end

NS_ASSUME_NONNULL_END
