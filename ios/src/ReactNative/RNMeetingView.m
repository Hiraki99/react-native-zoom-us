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
- (void) commonInit {
    [self addSubview:self.videoView];
    [self addSubview:self.preVideoView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoView.frame = self.bounds;
    self.preVideoView.frame = self.bounds;
}
- (MobileRTCActiveVideoView*)videoView
{
    if (!_videoView)
    {
        _videoView = [[MobileRTCActiveVideoView alloc] initWithFrame:self.bounds];
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
    [self.videoView removeFromSuperview];
    [self.preVideoView removeFromSuperview];
    self.videoView = nil;
    self.preVideoView = nil;
    [super dealloc];
}
@end
