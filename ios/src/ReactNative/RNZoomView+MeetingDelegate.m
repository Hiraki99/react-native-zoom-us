//
//  RNMeetingView+MeetingDelegate.m
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "RNZoomView+MeetingDelegate.h"

@implementation RNZoomView (MeetingDelegate)

- (void)onMeetingStateChange:(MobileRTCMeetingState)state
{
    NSLog(@"+++ onMeetingStateChange: %@", @(state));
}

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingActiveVideo: %@", @(userID));
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingAudioStatusChange: %@", @(userID));
}

- (void)onSinkMeetingMyAudioTypeChange
{
    NSLog(@"+++ onSinkMeetingMyAudioTypeChange");
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingVideoStatusChange: %@", @(userID));
}

- (void)onMyVideoStateChange
{
    NSLog(@"+++ onMyVideoStateChange");
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingUserJoin: %@", @(userID));
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingUserLeft: %@", @(userID));
}

- (void)onSinkMeetingActiveShare:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingActiveShare: %@", @(userID));
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    NSLog(@"+++ onSinkShareSizeChange: %@", @(userID));
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID
{
    NSLog(@"+++ onSinkMeetingShareReceiving: %@", @(userID));
}

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
    NSLog(@"+++ onWaitingRoomStatusChange: %@", @(needWaiting));
}

- (void)onSinkMeetingPreviewStopped
{
    NSLog(@"+++ onSinkMeetingPreviewStopped");
}

@end
