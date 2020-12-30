//
//  SDKStartJoinMeetingPresenter+CustomizedUIMeetingDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+CustomizedUIMeetingDelegate.h"
#import "OpenGLViewController.h"
#import "MeetingSettingsViewController.h"
#import "RNMeetingCenter.h"

@implementation SDKStartJoinMeetingPresenter (CustomizedUIMeetingDelegate)

- (void)onInitMeetingView
{
    NSLog(@"onInitMeetingView....");
    // Phunv: Su kien bat dau setup UI cua meetingRoom => Tai day khoi tao RNMeetingView va gan vao root view
    if ([[RNMeetingCenter shared] isEnableRNMeetingView]) {
        NSDictionary *userInfo = @{@"event": @"initMeetingView"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onMeetingEvent"
                                                            object:nil
                                                          userInfo:userInfo];
    }
    else {
        BOOL enbleRawdataUI = [[NSUserDefaults standardUserDefaults] boolForKey:Raw_Data_UI_Enable];

        if (!enbleRawdataUI) {
            CustomMeetingViewController *vc = [[CustomMeetingViewController alloc] init];
            self.customMeetingVC = vc;
            [vc release];

            [self.rootVC addChildViewController:self.customMeetingVC];
            [self.rootVC.view addSubview:self.customMeetingVC.view];
            [self.customMeetingVC didMoveToParentViewController:self.rootVC];

            self.customMeetingVC.view.frame = self.rootVC.view.bounds;
        } else { // RawData for Custom UI
            // Set raw data memory mode, The default is MobileRTCRawDataMemoryModeStack
    //        [[MobileRTC sharedRTC] setVideoRawDataMemoryMode:MobileRTCRawDataMemoryModeHeap];

            OpenGLViewController * roomVC = [[OpenGLViewController alloc] init];
            roomVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.rootVC presentViewController:roomVC animated:YES completion:nil];
        }
    }
}

- (void)onDestroyMeetingView
{
    NSLog(@"onDestroyMeetingView....");
    
    [self.customMeetingVC willMoveToParentViewController:nil];
    [self.customMeetingVC.view removeFromSuperview];
    [self.customMeetingVC removeFromParentViewController];
    [self.customMeetingVC release];
    self.customMeetingVC = nil;
}

@end
