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
    [[RNMeetingCenter shared] joinMeeting:meetingInfo];
    [RNMeetingCenter shared].currentMeetingDelegate = self;
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

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getParticipants)
{
    NSMutableArray *listUsers = [NSMutableArray new];
    for (NSNumber *userId in [[RNMeetingCenter shared] getParticipants]) {
        MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userId.integerValue];
        [listUsers addObject:@{@"userID": userId, @"userName": userInfo.userName}];
    }
    return listUsers;
}
RCT_EXPORT_METHOD(startObserverEvent)
{
    [[RNMeetingCenter shared] startObserverEvent];
}
RCT_EXPORT_METHOD(stopObserverEvent)
{
    [[RNMeetingCenter shared] stopObserverEvent];
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

- (void)onMeetingStateChange:(MobileRTCMeetingState)state {
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"meetingStateChange", @"state": @(state), @"des": [self convertStateToString:state]}];
}

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingActiveVideo", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingAudioStatusChange", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onSinkMeetingMyAudioTypeChange {
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingMyAudioTypeChange"}];
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingVideoStatusChange", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onMyVideoStateChange {
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"myVideoStateChange"}];
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingUserJoin", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingUserLeft", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onSinkMeetingActiveShare:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingActiveShare", @"userID": @(userID), @"userName": userInfo.userName}];
    
    [RNMeetingCenter shared].currentActiveShareUser = userID;
    NSDictionary *notiUserInfo = @{@"event": @"onSinkMeetingActiveShare", @"userID": @(userID)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                        object:nil
                                                      userInfo:notiUserInfo];
}

- (void)onSinkShareSizeChange:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkShareSizeChange", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID {
    MobileRTCMeetingUserInfo *userInfo = [[[MobileRTC sharedRTC] getMeetingService] userInfoByID:userID];
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingShareReceiving", @"userID": @(userID), @"userName": userInfo.userName}];
}

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting {
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"waitingRoomStatusChange", @"needWaiting": @(needWaiting)}];
}

- (void)onSinkMeetingPreviewStopped {
    [self sendEvent:@"onMeetingEvent" body:@{@"event": @"sinkMeetingPreviewStopped"}];
    
    NSDictionary *userInfo = @{@"event": @"sinkMeetingPreviewStopped"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void) sendEvent:(NSString *)eventName body:(NSDictionary *)bodyData
{
    if ([RNMeetingCenter shared].canSendEvent) {
        [self sendEventWithName:eventName body:bodyData];
    }
}
@end
