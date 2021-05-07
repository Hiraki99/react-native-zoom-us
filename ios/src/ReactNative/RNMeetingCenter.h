//
//  JoinMeetingUtils.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

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

- (void)onSinkMeetingVideoRequestUnmuteByHost;

- (void)onSinkMeetingAudioRequestUnmuteByHost;

@end

@class RNZoomView;

@interface RNMeetingCenter : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL canSendEvent;
@property (nonatomic, strong) NSDictionary *zoomClientInfo;
@property (nonatomic, strong) NSDictionary *meetingInfo;
@property (nonatomic, weak) id<MeetingDelegate> currentMeetingDelegate;

@property (nonatomic, assign) BOOL isJoinedRoom;
@property (nonatomic, assign) NSUInteger currentActiveShareUser;
@property (nonatomic, assign) NSUInteger currentActiveVideoUser;
@property (copy, nonatomic) RCTResponseSenderBlock initSDKCallback;

- (void) startObserverEvent;
- (void) stopObserverEvent;
- (void) setClientInfo:(NSDictionary *) clientInfo callBack:(RCTResponseSenderBlock) initSDKCallback;
- (void) joinMeeting:(NSDictionary *) meetingInfo;
- (void) joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rnZoomView:(id) rnZoomView;
- (void) joinRoomWithUserInfo:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion;
- (void) leaveCurrentMeeting;
- (void) checkPendingJoinMeetingAfterAuth;
- (BOOL) isEnableRNMeetingView;
- (void) onOffMyAudio;
- (void) onMyAudio;
- (void) offMyAudio;
- (void) onOffMyVideo;
- (void) switchMyCamera;
- (NSArray *) getParticipants;
@end

NS_ASSUME_NONNULL_END
