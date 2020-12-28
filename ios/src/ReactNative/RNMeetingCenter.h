//
//  JoinMeetingUtils.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MeetingDelegate <NSObject>

@optional

- (void)onMeetingStateChange:(MobileRTCMeetingState)state;

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID;

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID;

- (void)onSinkMeetingMyAudioTypeChange;

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID;

- (void)onMyVideoStateChange;

- (void)onSinkMeetingUserJoin:(NSUInteger)userID;

- (void)onSinkMeetingUserLeft:(NSUInteger)userID;

- (void)onSinkMeetingActiveShare:(NSUInteger)userID;

- (void)onSinkShareSizeChange:(NSUInteger)userID;

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID;

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting;

- (void)onSinkMeetingPreviewStopped;

@end

@class RNZoomView;

@interface RNMeetingCenter : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL canSendEvent;
@property (nonatomic, strong) NSDictionary *zoomClientInfo;
@property (nonatomic, strong) NSDictionary *meetingInfo;
@property (nonatomic, weak) id<MeetingDelegate> currentMeetingDelegate;

- (void) startObserverEvent;
- (void) stopObserverEvent;
- (void) setClientInfo:(NSDictionary *) clientInfo;
- (void) joinMeeting:(NSDictionary *) meetingInfo;
- (void) joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rnZoomView:(id) rnZoomView;
- (void) joinRoomWithUserInfo:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion;
- (void) leaveCurrentMeeting;
- (void) checkPendingJoinMeetingAfterAuth;
- (BOOL) isEnableRNMeetingView;
- (void) onOffMyAudio;
- (void) onOffMyVideo;
- (void) switchMyCamera;
- (NSArray *) getParticipants;
@end

NS_ASSUME_NONNULL_END
