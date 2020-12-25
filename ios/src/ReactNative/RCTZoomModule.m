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
    return [[RNMeetingCenter shared] getParticipants];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
