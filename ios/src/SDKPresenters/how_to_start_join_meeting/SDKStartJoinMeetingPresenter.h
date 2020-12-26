//
//  SDKStartJoinMeetingPresenter.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/15.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "CustomMeetingViewController.h"
#import "RNMeetingView.h"
#import "RNZoomView.h"

@interface SDKStartJoinMeetingPresenter : NSObject 

- (void)startMeeting:(BOOL)appShare rootVC:(UIViewController *)rootVC;

- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rootVC:(UIViewController *)rootVC;
// Phunv: Ham nay de join meeting voi rnZoomView, number meeting room, pwd
- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rnZoomView:(UIView *)zoomView;
@property (retain, nonatomic) UIViewController *rootVC;
// Phunv: rnZoomView la phan luu thong tin zoomView hien tai, duoc su dung de keep ref zoomView sau nay can tuong tac addView, handle xu ly cac event...
@property (retain, nonatomic) RNZoomView *rnZoomView;

@property (retain, nonatomic) CustomMeetingViewController *customMeetingVC;

@property (retain, nonatomic) MainViewController *mainVC;


@end

