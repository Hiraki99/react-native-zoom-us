//
//  RNMeetingView+MeetingDelegate.h
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNZoomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNZoomView (MeetingDelegate)

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

NS_ASSUME_NONNULL_END
