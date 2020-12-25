//
//  WrapperView.m
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "RNZoomView.h"
#import "RNMeetingView.h"
#import "RNMeetingCenter.h"

@interface RNZoomView() {
}
@property (strong, nonatomic) NSDictionary *zoomDic;
@end

@implementation RNZoomView

-(void)reactSetFrame:(CGRect)frame{
    self.frame=frame;
}

- (void) setZoomInfo:(NSDictionary *) zoomInfo {
    if (!self.zoomDic) {
        self.zoomDic = [[NSDictionary alloc] initWithDictionary:zoomInfo];
        [self startJoinRoom];
    }
}

- (void) startJoinRoom {
    NSString *roomNumber = self.zoomDic[@"roomNumber"] ?: @"";
    NSString *roomPassword = self.zoomDic[@"roomPassword"] ?: @"";
    [[RNMeetingCenter shared] joinMeeting:roomNumber withPassword:roomPassword rnZoomView:self];
}
- (void) joinRoomWithUserInfo:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion {
    NSString *userDisplayName = self.zoomDic[@"userDisplayName"] ?: @"";
    NSString *userPassword = self.zoomDic[@"userPassword"] ?: @"";
    completion(userDisplayName, userPassword, NO);
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void) commonInit {
}
- (void) createMeetingView {
    if (!self.rnMeetingView) {
        self.rnMeetingView = [[RNMeetingView alloc] initWithFrame:self.bounds];
        [self addSubview:self.rnMeetingView];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.rnMeetingView.frame = self.bounds;
}

@end
