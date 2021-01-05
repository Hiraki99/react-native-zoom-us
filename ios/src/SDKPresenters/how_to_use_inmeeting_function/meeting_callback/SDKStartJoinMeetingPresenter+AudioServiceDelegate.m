//
//  SDKStartJoinMeetingPresenter+AudioServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+AudioServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"
#import "RNZoomView+MeetingDelegate.h"
#import "RNMeetingCenter.h"

@implementation SDKStartJoinMeetingPresenter (AudioServiceDelegate)

#pragma mark - Audio Service Delegate

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingAudioStatusChange:userID];
    }
    // Phunv: onSinkMeetingAudioStatusChange
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingAudioStatusChange:userID];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingAudioStatusChange:userID];
    }
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID audioStatus:(MobileRTC_AudioStatus)audioStatus
{
    NSLog(@"onSinkMeetingAudioStatusChange=%@, audioStatus=%@",@(userID), @(audioStatus));
}

- (void)onSinkMeetingMyAudioTypeChange
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingMyAudioTypeChange];
    }
    // Phunv: onSinkMeetingMyAudioTypeChange
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingMyAudioTypeChange];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingMyAudioTypeChange];
    }
}

- (void)onMyAudioStateChange
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingAudioStatusChange:0];
    }
    // Phunv: onSinkMeetingAudioStatusChange
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingAudioStatusChange:0];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingAudioStatusChange:0];
    }
}

// Phunv: Comment doan code #if nay nhe
// #if 0
- (void)onSinkMeetingAudioRequestUnmuteByHost
{
    //NSLog(@"the host require meeting attendants to enable microphone");
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingAudioRequestUnmuteByHost];
    }
}
//#endif

@end
