//
//  RNMeetingView.m
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "RNMeetingView.h"
#import "RNMeetingCenter.h"

@interface RNMeetingView() {
    NSString *currentUserID;
    CGRect reactFrame;
}
@end

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUserID2:userID force:YES];
    });
}
- (void) setUserID3:(NSString *)userID {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUserID2:userID force:YES];
    });
}
- (void) setUserID2:(NSString *)userID force:(BOOL) force {
    if ((currentUserID && ![currentUserID isEqualToString: userID]) || force) {
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
        if (_activeShareView) {
            [_activeShareView stopActiveShare];
            [_activeShareView removeFromSuperview];
            _activeShareView = nil;
        }
    }
    currentUserID = userID;
    if ([userID isEqualToString:@"local_user"]) {
        BOOL isJoined = NO;
        if ([[MobileRTC sharedRTC] getMeetingService] && [[[MobileRTC sharedRTC] getMeetingService] myselfUserID] > 0) {
            isJoined = YES;
            if (!_videoView) {
                [self addSubview:self.videoView];
            }
        }
        else {
            if (!_preVideoView) {
                [self addSubview:self.preVideoView];
            }
        }
        [_videoView setHidden: isJoined ? NO : YES];
        [_preVideoView setHidden: isJoined ? YES : NO];
        if (isJoined) {
            [_videoView showAttendeeVideoWithUserID: [[[MobileRTC sharedRTC] getMeetingService] myselfUserID]];
        }
    }
    else if ([userID isEqualToString:@"active_user"]) {
        if (!_activeVideoView) {
            [self addSubview:self.activeVideoView];
        }
        if (!_activeShareView) {
            [self addSubview:self.activeShareView];
        }
        if ([RNMeetingCenter shared].currentActiveShareUser > 0) {
            [_activeShareView setHidden:NO];
            [_activeShareView showActiveShareWithUserID:[RNMeetingCenter shared].currentActiveShareUser];
        }
        else {
            [_activeShareView setHidden:YES];
            [_activeShareView stopActiveShare];
            if ([RNMeetingCenter shared].currentActiveVideoUser > 0) {
                [_activeVideoView showAttendeeVideoWithUserID:[RNMeetingCenter shared].currentActiveVideoUser];
            }
        }
    }
    else {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([userID rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSUInteger userIDInt = [userID integerValue];
            if (!_videoView) {
                [self addSubview:self.videoView];
                [_videoView showAttendeeVideoWithUserID:userIDInt];
            }
            else {
                [_videoView showAttendeeVideoWithUserID:userIDInt];
            }
        }
    }
}
- (void) commonInit {
    currentUserID = nil;
    reactFrame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    [_videoView stopAttendeeVideo];
    [_preVideoView stopAttendeeVideo];
    [_activeVideoView stopAttendeeVideo];
    [_activeShareView stopActiveShare];
    
    [_videoView removeFromSuperview];
    [_preVideoView removeFromSuperview];
    [_activeVideoView removeFromSuperview];
    [_activeShareView removeFromSuperview];
    
    _videoView = nil;
    _preVideoView = nil;
    _activeVideoView = nil;
    _activeShareView = nil;
}

- (void) handleEventPreviewStopped {
    if ([[[MobileRTC sharedRTC] getMeetingService] myselfUserID] > 0 && (_preVideoView || (currentUserID && [currentUserID length] > 0 && [currentUserID integerValue] == [[[MobileRTC sharedRTC] getMeetingService] myselfUserID])))
    {
        [_preVideoView setHidden:YES];
        [_videoView setHidden:NO];
        [_videoView showAttendeeVideoWithUserID: [[[MobileRTC sharedRTC] getMeetingService] myselfUserID]];
    }
}
- (void) handleUserActiveShare: (NSNumber *) userID {
    if (userID.integerValue > 0) {
        [_activeShareView setHidden:NO];
        [_activeShareView showActiveShareWithUserID:userID.integerValue];
    }
    else {
        [_activeShareView stopActiveShare];
        [_activeShareView setHidden:YES];
    }
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

- (MobileRTCActiveShareView *) activeShareView {
    if (!_activeShareView)
    {
        _activeShareView = [[MobileRTCActiveShareView alloc] initWithFrame:self.bounds];
        [_activeShareView setVideoAspect:MobileRTCVideoAspect_PanAndScan];
    }
    return _activeShareView;
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
- (void) updateFrame:(CGRect) frame {
    self.frame = frame;
    if (frame.size.width != reactFrame.size.width || frame.size.height != reactFrame.size.height) {
        reactFrame = frame;
        // Tao lai view o day
        if (currentUserID) {
            [self setUserID3:currentUserID];
        }
    }
}
@end
