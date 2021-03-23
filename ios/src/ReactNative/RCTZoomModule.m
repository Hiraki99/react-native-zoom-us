//
//  OGWaveManager.m
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 10/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RCTZoomModule.h"
#import "RNMeetingCenter.h"

@implementation RCTZoomModule

// To export a module named RCTZoomModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initZoomSDK:(NSDictionary *) clientInfo)
{
    [[RNMeetingCenter shared] setClientInfo:clientInfo];
}

RCT_EXPORT_METHOD(joinMeeting:(NSDictionary *) meetingInfo)
{
    [RNMeetingCenter shared].currentMeetingDelegate = self;
    [[RNMeetingCenter shared] joinMeeting:meetingInfo];
}

RCT_EXPORT_METHOD(leaveCurrentMeeting)
{
    [[RNMeetingCenter shared] leaveCurrentMeeting];
}

RCT_EXPORT_METHOD(onOffMyAudio)
{
    [[RNMeetingCenter shared] onOffMyAudio];
}

RCT_EXPORT_METHOD(onOffMyVideo)
{
    [[RNMeetingCenter shared] onOffMyVideo];
}

RCT_EXPORT_METHOD(switchMyCamera)
{
    [[RNMeetingCenter shared] switchMyCamera];
}

RCT_EXPORT_METHOD(getParticipants:(RCTResponseSenderBlock)callback)
{
    NSMutableArray *listUsers = [NSMutableArray new];
    for (NSNumber *userId in [[RNMeetingCenter shared] getParticipants]) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userId.integerValue];
        [listUsers addObject:
         @{
             @"userID": userId,
             @"userName": userInfo.userName ?: @"",
             @"videoStatus": userInfo && userInfo.videoStatus.isSending ? @1 : @0,
             @"audioStatus": userInfo && userInfo.audioStatus.isMuted ? @0 : @1,
             @"videoRatio": [self getVideoRatio:userId.unsignedIntegerValue],
             @"isHost": userInfo && userInfo.isHost ? @1 : @0
         }];
    }
    callback(@[[NSNull null], listUsers]);
}
RCT_EXPORT_METHOD(getUserInfo:(NSString *)userIdStr callback:(RCTResponseSenderBlock)callback)
{
    NSUInteger userID = 0;
    if ([userIdStr isEqual:@"local_user"]) {
        userID = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
    }
    else if ([userIdStr isEqual:@"active_user"]) {
        userID = [RNMeetingCenter shared].currentActiveVideoUser;
    }
    else {
        userID = [userIdStr integerValue];
    }
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    NSDictionary *reponse =
    @{
        @"userID": @(userID),
        @"userName": userInfo.userName ?: @"",
        @"videoStatus": userInfo && userInfo.videoStatus.isSending ? @1 : @0,
        @"audioStatus": userInfo && userInfo.audioStatus.isMuted ? @0 : @1,
        @"videoRatio": [self getVideoRatio:userID],
        @"isHost": userInfo && userInfo.isHost ? @1 : @0
    };
    callback(@[[NSNull null], reponse]);
}

RCT_EXPORT_METHOD(startObserverEvent)
{
    [[RNMeetingCenter shared] startObserverEvent];
}
RCT_EXPORT_METHOD(stopObserverEvent)
{
    [[RNMeetingCenter shared] stopObserverEvent];
}
RCT_EXPORT_METHOD(setHostUser:(NSString *)userID)
{
    if ([[MobileRTC sharedRTC] getMeetingService]) {
        if (userID && userID.length > 0) {
            NSInteger userIDInt = [userID integerValue];
            NSInteger myUserID = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
            if (myUserID > 0 && userIDInt > 0) {
                BOOL iAmHost = [[[MobileRTC sharedRTC] getMeetingService] isHostUser:myUserID];
                if (iAmHost) {
                    [[[MobileRTC sharedRTC] getMeetingService] makeHost:userIDInt];
                }
            }
        }
    }
}
RCT_EXPORT_METHOD(raiseMyHand)
{
    if ([[MobileRTC sharedRTC] getMeetingService]) {
        NSInteger myUserID = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
        if (myUserID > 0) {
            [[[MobileRTC sharedRTC] getMeetingService] raiseMyHand];
        }
    }
}
RCT_EXPORT_METHOD(lowerHand)
{
    if ([[MobileRTC sharedRTC] getMeetingService]) {
        NSInteger myUserID = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
        if (myUserID > 0) {
            [[[MobileRTC sharedRTC] getMeetingService] lowerHand:myUserID];
        }
    }
}
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
- (NSArray<NSString *> *)supportedEvents {
    return @[@"onMeetingEvent"];
}

// Meeting delegate
- (NSString *) convertStateToString: (MobileRTCMeetingState) state {
    switch (state) {
        case MobileRTCMeetingState_Idle:///<No meeting is running
            return @"no_meeting_running";
        case MobileRTCMeetingState_Connecting:///<Connect to the meeting server status
            return @"connecting_meeting_server";
        case MobileRTCMeetingState_WaitingForHost:///<Waiting for the host to start the meeting.
            return @"waiting_host_start_meeting";
        case MobileRTCMeetingState_InMeeting:///<Meeting is ready, in meeting status.
            [RNMeetingCenter shared].isJoinedRoom = YES;
            return @"meeting_ready";
        case MobileRTCMeetingState_Disconnecting:///<Disconnect the meeting server, leave meeting status.
            return @"disconnect_meeting server";
        case MobileRTCMeetingState_Reconnecting:///<Reconnecting meeting server status.
            return @"reconnecting_meeting_server";
        case MobileRTCMeetingState_Failed:///<Failed to connect the meeting server.
            return @"failed_connect_meeting_server";
        case MobileRTCMeetingState_Ended:///<Meeting ends
            [RNMeetingCenter shared].isJoinedRoom = NO;
            [RNMeetingCenter shared].currentActiveShareUser = 0;
            [RNMeetingCenter shared].currentActiveVideoUser = 0;
            return @"meeting_end";
        case MobileRTCMeetingState_Unknow:///<Unknown status.
            return @"unknown_status";
        case MobileRTCMeetingState_Locked:///<Meeting is locked to prevent the further participants to join the meeting.
            return @"meeting_locked_prevent_further_participants";
        case MobileRTCMeetingState_Unlocked:///<Meeting is open and participants can join the meeting.
            return @"meeting_open_participants_can_join";
        case MobileRTCMeetingState_InWaitingRoom:///<Participants who join the meeting before the start are in the waiting room.
            return @"in_waiting_room";
        case MobileRTCMeetingState_WebinarPromote:///<Upgrade the attendees to panelist in webinar.
            return @"upgrade_attendees_panelist";
        case MobileRTCMeetingState_WebinarDePromote:///<Downgrade the attendees from the panelist.
            return @"downgrade_attendees_panelist";
        case MobileRTCMeetingState_JoinBO:///<Join the breakout room.
            return @"join_breakout_room";
        case MobileRTCMeetingState_LeaveBO:///<Leave the breakout room.
            return @"leave_breakout_room";
        case MobileRTCMeetingState_WaitingExternalSessionKey:///<Waiting for the additional secret key.
            return @"waiting_additional_secret_key";
    }
    return @"unknown_status";
}
- (NSNumber *) getVideoRatio: (NSUInteger) userID {
    CGSize size = [[[MobileRTC sharedRTC] getMeetingService] getUserVideoSize:userID];
    if (size.width > 0 && size.height > 0) {
        CGFloat ratio = size.height / size.width;
        return @(ratio);
    }
    return @0;
}
- (void)onMeetingStateChange:(MobileRTCMeetingState)state {
    [self sendEvent:@"onMeetingEvent"
               body:@{
                   @"event": @"meetingStateChange",
                   @"state": @(state),
                   @"des": [self convertStateToString:state]
               }];
}

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID {
    if (userID > 0) {
        [RNMeetingCenter shared].currentActiveVideoUser = userID;
    }
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    
    [self sendEvent:@"onMeetingEvent"
               body:@{
                   @"event": @"sinkMeetingActiveVideo",
                   @"userID": @(userID),
                   @"userName": userInfo.userName ?: @""
               }];
    NSDictionary *userInfo2 = @{@"event": @"sinkMeetingActiveVideo", @"userID": @(userID)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                        object:nil
                                                      userInfo:userInfo2];
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingAudioStatusChange",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @"",
                       @"audioStatus": userInfo && userInfo.audioStatus.isMuted ? @0 : @1
                   }];
    }
}

- (void)onSinkMeetingMyAudioTypeChange {
    NSUInteger myUserID = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
    if (myUserID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:myUserID];
        
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingMyAudioTypeChange",
                       @"audioStatus": userInfo && userInfo.audioStatus.isMuted ? @0 : @1
                   }];
    }
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingVideoStatusChange",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @"",
                       @"videoStatus": userInfo && userInfo.videoStatus.isSending ? @1 : @0,
                       @"videoRatio": [self getVideoRatio:userID]
                   }];
        
        NSDictionary *userInfo2 = @{@"event": @"sinkMeetingVideoStatusChange", @"userID": @(userID)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                            object:nil
                                                          userInfo:userInfo2];
    }
}

- (void)onMyVideoStateChange {
    NSUInteger myUserID = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
    if (myUserID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:myUserID];
        
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"myVideoStateChange",
                       @"videoStatus": userInfo && userInfo.videoStatus.isSending ? @1 : @0,
                       @"videoRatio": [self getVideoRatio:myUserID]
                   }];
        NSDictionary *userInfo2 = @{@"event": @"sinkMeetingVideoStatusChange", @"userID": @(myUserID)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                            object:nil
                                                          userInfo:userInfo2];
    }
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingUserJoin",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @"",
                       @"videoStatus": userInfo && userInfo.videoStatus.isSending ? @1 : @0,
                       @"audioStatus": userInfo && userInfo.audioStatus.isMuted ? @0 : @1,
                       @"videoRatio": [self getVideoRatio:userID],
                       @"isHost": userInfo && userInfo.isHost ? @1 : @0
                   }];
    }
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingUserLeft",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @""
                   }];
    }
}

- (void)onSinkMeetingActiveShare:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingActiveShare",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @""
                   }];
        if (userID > 0) {
            [RNMeetingCenter shared].currentActiveShareUser = userID;
        }
        NSDictionary *notiUserInfo = @{@"event": @"onSinkMeetingActiveShare", @"userID": @(userID)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                            object:nil
                                                          userInfo:notiUserInfo];
    }
}

- (void)onSinkShareSizeChange:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkShareSizeChange",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @""
                   }];
    }
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID {
    if (userID > 0) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
        [self sendEvent:@"onMeetingEvent"
                   body:@{
                       @"event": @"sinkMeetingShareReceiving",
                       @"userID": @(userID),
                       @"userName": userInfo.userName ?: @""
                   }];
    }
}

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting {
    [self sendEvent:@"onMeetingEvent"
               body:@{
                   @"event": @"waitingRoomStatusChange",
                   @"needWaiting": @(needWaiting)
               }];
}

- (void)onSinkMeetingPreviewStopped {
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingPreviewStopped"}];
    
    NSDictionary *userInfo = @{@"event": @"sinkMeetingPreviewStopped"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)onSinkMeetingVideoRequestUnmuteByHost {
    [self sendEvent:@"onMeetingEvent"
               body:@{@"event": @"sinkMeetingVideoRequestUnmuteByHost"}];
}

- (void)onSinkMeetingAudioRequestUnmuteByHost {
    [self sendEvent:@"onMeetingEvent"
               body:@{@"event": @"sinkMeetingAudioRequestUnmuteByHost"}];
}

- (void) sendEvent:(NSString *)eventName body:(NSDictionary *)bodyData
{
    if ([RNMeetingCenter shared].canSendEvent) {
        [self sendEventWithName:eventName body:bodyData];
    }
}
@end
