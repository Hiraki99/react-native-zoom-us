//
//  RNMeetingView.m
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "RNMeetingView.h"

@implementation RNMeetingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
- (void) setUserID:(NSString *)userID {
    if (_videoView) {
        [_videoView stopAttendeeVideo];
        [_videoView removeFromSuperview];
        _videoView = nil;
    }
    if (_preVideoView) {
        [_preVideoView stopAttendeeVideo];
        [_preVideoView removeFromSuperview];
        _preVideoView = nil;
    }
    if (_activeVideoView) {
        [_activeVideoView stopAttendeeVideo];
        [_activeVideoView removeFromSuperview];
        _activeVideoView = nil;
    }
    if ([userID isEqualToString:@"local_user"]) {
        BOOL isJoined = NO;
        if ([[MobileRTC sharedRTC] getMeetingService] && [[[MobileRTC sharedRTC] getMeetingService] myselfUserID] > 0) {
            isJoined = YES;
        }
        if (!_videoView) {
            [self addSubview:self.videoView];
        }
        if (!_preVideoView) {
            [self addSubview:self.preVideoView];
        }
        [_videoView setHidden: isJoined ? NO : YES];
        [_preVideoView setHidden: isJoined ? YES : NO];
        [_videoView showAttendeeVideoWithUserID: [[[MobileRTC sharedRTC] getMeetingService] myselfUserID]];
    }
    else if ([userID isEqualToString:@"active_user"]) {
        if (!_activeVideoView) {
            [self addSubview:self.activeVideoView];
        }
    }
    else {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([userID rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            if (!_videoView) {
                NSUInteger userIDInt = [userID integerValue];
                [self addSubview:self.videoView];
                [_videoView showAttendeeVideoWithUserID:userIDInt];
            }
        }
    }
}
- (void) commonInit {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _videoView.frame = self.bounds;
    _preVideoView.frame = self.bounds;
    _activeVideoView.frame = self.bounds;
}

- (MobileRTCActiveVideoView*)activeVideoView
{
    if (!_activeVideoView)
    {
        _activeVideoView = [[MobileRTCActiveVideoView alloc] initWithFrame:self.bounds];
        [_activeVideoView setVideoAspect:MobileRTCVideoAspect_PanAndScan];
    }
    return _activeVideoView;
}

- (MobileRTCVideoView*)videoView
{
    if (!_videoView)
    {
        _videoView = [[MobileRTCVideoView alloc] initWithFrame:self.bounds];
        [_videoView setVideoAspect:MobileRTCVideoAspect_PanAndScan];
    }
    return _videoView;
}

- (MobileRTCPreviewVideoView*)preVideoView
{
    if (!_preVideoView)
    {
        _preVideoView = [[MobileRTCPreviewVideoView alloc] initWithFrame:self.bounds];
    }
    return _preVideoView;
}
- (void)dealloc {
    [_videoView stopAttendeeVideo];
    [_preVideoView stopAttendeeVideo];
    [_activeVideoView stopAttendeeVideo];
    
    [_videoView removeFromSuperview];
    [_preVideoView removeFromSuperview];
    [_activeVideoView removeFromSuperview];
    
    _videoView = nil;
    _preVideoView = nil;
    _activeVideoView = nil;
}

- (void) handleEventPreviewStopped {
    if ([[[MobileRTC sharedRTC] getMeetingService] myselfUserID] > 0) {
        [_preVideoView setHidden:YES];
        [_videoView setHidden:NO];
        [_videoView showAttendeeVideoWithUserID: [[[MobileRTC sharedRTC] getMeetingService] myselfUserID]];
    }
}

@end
