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

- (void) reactSetFrame:(CGRect)frame{
    self.frame=frame;
    if (_rnMeetingView) {
        [_rnMeetingView updateFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

- (void) setUserID:(NSString *)userID {
    if (userID && userID.length > 0) {
        BOOL hasChange = YES;
        if (_userID && [_userID isEqualToString:userID]) {
            hasChange = NO;
        }
        if (hasChange) {
            _userID = userID;
            if (_rnMeetingView) {
                [_rnMeetingView setUserID: userID];
            }
            else {
                if ([RNMeetingCenter shared].isJoinedRoom) {
                    [self createMeetingView];
                }
            }
        }
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMeetingEvent:)
                                                 name:@"onMeetingEvent"
                                               object:nil];
}
- (void) handleMeetingEvent:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"onMeetingEvent"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *event = userInfo[@"event"];
        if ([event isEqualToString:@"sinkMeetingPreviewStopped"]) {
            [self handleEventPreviewStopped];
        }
        if ([event isEqualToString:@"initMeetingView"]) {
            [self createMeetingView];
        }
        if ([event isEqualToString:@"endMeeting"]) {
            if (_rnMeetingView) {
                [_rnMeetingView removeFromSuperview];
                _rnMeetingView = nil;
            }
        }
        if ([event isEqualToString:@"onSinkMeetingActiveShare"]) {
            if (_rnMeetingView) {
                NSNumber *userID = userInfo[@"userID"];
                [_rnMeetingView handleUserActiveShare: userID];
            }
        }
        if ([event isEqualToString:@"sinkMeetingVideoStatusChange"] || [event isEqualToString:@"sinkMeetingActiveVideo"]) {
            if (_rnMeetingView) {
                NSNumber *userID = userInfo[@"userID"];
                if (_userID && [_userID isEqualToString:[NSString stringWithFormat:@"%@", userID]]) {
                    [_rnMeetingView setUserID:_userID];
                }
            }
        }
    }
}
- (void) createMeetingView {
    if (!_rnMeetingView) {
        _rnMeetingView = [[RNMeetingView alloc] initWithFrame:self.bounds];
        [_rnMeetingView updateFrame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [_rnMeetingView setUserID:_userID];
        [self addSubview:_rnMeetingView];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void) handleEventPreviewStopped {
    [_rnMeetingView handleEventPreviewStopped];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_rnMeetingView removeFromSuperview];
    _rnMeetingView = nil;
}
@end
