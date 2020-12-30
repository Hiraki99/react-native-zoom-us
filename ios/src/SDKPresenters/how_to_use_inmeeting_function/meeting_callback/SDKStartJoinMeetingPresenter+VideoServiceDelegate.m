//
//  SDKStartJoinMeetingPresenter+VideoServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+VideoServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"
#import "RNZoomView+MeetingDelegate.h"
#import "RNMeetingCenter.h"

@implementation SDKStartJoinMeetingPresenter (VideoServiceDelegate)

#pragma mark - Video Service Delegate

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingActiveVideo:userID];
    }
    // Phunv: onSinkMeetingActiveVideo
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingActiveVideo:userID];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingActiveVideo:userID];
    }
}

- (void)onSinkMeetingPreviewStopped
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingPreviewStopped];
    }
    // Phunv: onSinkMeetingPreviewStopped
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingPreviewStopped];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingPreviewStopped];
    }
}


- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingVideoStatusChange:userID];
    }
    // Phunv: onSinkMeetingVideoStatusChange
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingVideoStatusChange:userID];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingVideoStatusChange:userID];
    }
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID videoStatus:(MobileRTC_VideoStatus)videoStatus
{
    NSLog(@"onSinkMeetingVideoStatusChange=%@, videoStatus=%@",@(userID), @(videoStatus));
}

- (void)onMyVideoStateChange
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onMyVideoStateChange];
    }
    // Phunv: onMyVideoStateChange
    if (self.rnZoomView) {
        [self.rnZoomView onMyVideoStateChange];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onMyVideoStateChange];
    }
}

- (void)onSinkMeetingVideoQualityChanged:(MobileRTCNetworkQuality)qality userID:(NSUInteger)userID
{
    NSLog(@"onSinkMeetingVideoQualityChanged: %zd userID:%zd",qality,userID);
}

- (void)onSinkMeetingVideoRequestUnmuteByHost:(void (^)(BOOL Accept))completion
{
    if (completion)
    {
        completion(YES);
    }
}

@end
