//
//  SDKStartJoinMeetingPresenter+JoinMeetingOnly.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/20.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+JoinMeetingOnly.h"
#import "RNMeetingCenter.h"

@implementation SDKStartJoinMeetingPresenter (JoinMeetingOnly)

- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd
{
    // Phunv: Join meetingNo with pwd
    if (![meetingNo length])
        return;
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms)
    {
#if 0
        //customize meeting title
        [ms customizeMeetingTitle:@"Sample Meeting Title"];
#endif
        
        //For Join a meeting with password
        MobileRTCMeetingJoinParam * joinParam = [[[MobileRTCMeetingJoinParam alloc]init]autorelease];
        // Phunv: truyen param username
        NSString *userName = [RNMeetingCenter shared].meetingInfo ? ([RNMeetingCenter shared].meetingInfo[@"userName"] ?: @"") : @"";
        joinParam.userName = userName;
        joinParam.meetingNumber = meetingNo;
        joinParam.password = pwd;
        
        // Phunv: Them doan code nhan tham so truyen bat/tat audio/video
        BOOL enableAudio = YES;
        BOOL enableVideo = NO;
        
        if ([RNMeetingCenter shared].meetingInfo) {
            NSNumber *audioValue = [RNMeetingCenter shared].meetingInfo[@"enableAudio"];
            NSNumber *videoValue = [RNMeetingCenter shared].meetingInfo[@"enableVideo"];
            
            if (audioValue) {
                enableAudio = audioValue.boolValue;
            }
            if (videoValue) {
                enableVideo = videoValue.boolValue;
            }
        }
        joinParam.noAudio = enableAudio ? NO : YES;
        joinParam.noVideo = enableVideo ? NO : YES;
//        joinParam.zak = kZAK;
//        joinParam.participantID = kParticipantID;
//        joinParam.webinarToken = kWebinarToken;
//        joinParam.noAudio = YES;
//        joinParam.noVideo = YES;
        
        MobileRTCMeetError ret = [ms joinMeetingWithJoinParam:joinParam];
        
        NSLog(@"onJoinaMeeting ret:%d", ret);

    }
}

@end
