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

@property (nonatomic, strong) NSDictionary *zoomClientInfo;
@property (nonatomic, weak) RNZoomView *currentZoomView;

- (void) setClientInfo:(NSDictionary *) clientInfo;
- (void) joinMeeting:(NSDictionary *) meetingInfo;
- (void) joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rnZoomView:(id) rnZoomView;
- (void) leaveCurrentMeeting;
- (void) checkPendingJoinMeetingAfterAuth;
- (BOOL) isEnableRNMeetingView;
- (void) onOffMyAudio;
- (void) onOffMyVideo;
- (void) switchMyCamera;
- (NSArray *) getParticipants;
@end

NS_ASSUME_NONNULL_END
