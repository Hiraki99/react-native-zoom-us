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
    UIImage *lastFrameImage;
    NSString *lastFrameUserID;
    NSTimer *timerHideLastFrame;
    NSTimeInterval timeStampSetUserID;
}

@end

@implementation RNZoomView

- (void) reactSetFrame:(CGRect)frame {
    self.frame=frame;
    if (_rnMeetingView) {
        [_rnMeetingView updateFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _captureImage.frame = self.bounds;
    }
}

- (UIImage *)captureVideo:(UIView *)view
{
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:view.bounds.size];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
        }];
    } else {
        // Fallback on earlier versions
        return nil;
    }
}

- (void) setUserID:(NSString *)userID {
    if (userID) {
        BOOL hasChange = YES;
        if (_userID && [_userID isEqualToString:userID]) {
            hasChange = NO;
        }
        if (hasChange) {
            if (_userID.length > 0 && _rnMeetingView) {
                if (!lastFrameImage) {
                    lastFrameUserID = _userID;
                    lastFrameImage = [self captureVideo:_rnMeetingView];
                }
                else if ([_rnMeetingView hasVideo]) {
                    lastFrameUserID = _userID;
                    lastFrameImage = [self captureVideo:_rnMeetingView];
                }                
            }
            _userID = userID;
            timeStampSetUserID = [[NSDate date] timeIntervalSince1970];
            if (_rnMeetingView) {
                [_rnMeetingView setUserID: userID];
                [self showLastFrame];
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
                    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
                    //if (currentTime - timeStampSetUserID >= 0.5) {
                        [self hideLastFrame];
                    //}
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
        
        _captureImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _captureImage.layer.zPosition = MAXFLOAT;
        [_captureImage setHidden:NO];
        [self addSubview:_captureImage];
    }
    [self showLastFrame];
}
- (void) showLastFrame {
    if (timerHideLastFrame) {
        [timerHideLastFrame invalidate];
        timerHideLastFrame = nil;
    }
    if (lastFrameImage && lastFrameUserID && ([lastFrameUserID isEqualToString:_userID] || (!_userID || _userID.length == 0))) {
        [_captureImage setImage:lastFrameImage];
        [_captureImage setHidden:NO];
        timerHideLastFrame = [NSTimer scheduledTimerWithTimeInterval:1.0
            target:self
            selector:@selector(hideLastFrame)
            userInfo:nil
            repeats:NO];
    }
    else {
        [_rnMeetingView setHidden:YES];
        [_captureImage setHidden:YES];
        timerHideLastFrame = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(hideLastFrame)
                                                            userInfo:nil
                                                             repeats:NO];
    }
}
- (void) hideLastFrame {
    if (_userID && _userID.length > 0) {
        if (timerHideLastFrame) {
            [timerHideLastFrame invalidate];
            timerHideLastFrame = nil;
        }
        [_captureImage setHidden:YES];
        [_rnMeetingView setHidden:NO];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void) handleEventPreviewStopped {
    [_rnMeetingView handleEventPreviewStopped];
}
- (void)dealloc {
    if (timerHideLastFrame) {
        [timerHideLastFrame invalidate];
        timerHideLastFrame = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_rnMeetingView removeFromSuperview];
    _rnMeetingView = nil;
    
    [_captureImage setImage: nil];
    [_captureImage removeFromSuperview];
    _captureImage = nil;
    
    lastFrameImage = nil;
    lastFrameUserID = nil;
}
@end
