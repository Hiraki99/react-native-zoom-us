//
//  SDKStartJoinMeetingPresenter+ShareServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+ShareServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"
#import "MainViewController+MeetingDelegate.h"
#import "RNZoomView+MeetingDelegate.h"
#import "RNMeetingCenter.h"

@implementation SDKStartJoinMeetingPresenter (ShareServiceDelegate)

- (void)onSinkMeetingActiveShare:(NSUInteger)userID
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingActiveShare:userID];
    }
    // Phunv: onSinkMeetingActiveShare
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingActiveShare:userID];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingActiveShare:userID];
    }
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkShareSizeChange:userID];
    }
    // Phunv: onSinkShareSizeChange
    if (self.rnZoomView) {
        [self.rnZoomView onSinkShareSizeChange:userID];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkShareSizeChange:userID];
    }
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingShareReceiving:userID];
    }
    // Phunv: onSinkMeetingShareReceiving
    if (self.rnZoomView) {
        [self.rnZoomView onSinkMeetingShareReceiving:userID];
    }
    if ([RNMeetingCenter shared].currentMeetingDelegate) {
        [[RNMeetingCenter shared].currentMeetingDelegate onSinkMeetingShareReceiving:userID];
    }
}

- (void)onAppShareSplash
{
    if (self.mainVC) {
        [self.mainVC onAppShareSplash];
    }
}



@end
