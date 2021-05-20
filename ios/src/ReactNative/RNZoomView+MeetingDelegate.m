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
}

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID audioStatus:(MobileRTC_AudioStatus)audioStatus
{
}

- (void)onSinkMeetingMyAudioTypeChange
{
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID videoStatus:(MobileRTC_VideoStatus)videoStatus
{
}

- (void)onMyVideoStateChange
{
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID
{
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID
{
}

- (void)onSinkMeetingActiveShare:(NSUInteger)userID
{
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID
{
}

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
}

- (void)onSinkMeetingPreviewStopped
{
}

@end
