//
//  ShareScreenViewManager.m
//  react-native-video-zoom-sdk
//
//  Created by Phu on 6/4/21.
//

#import "ShareScreenViewManager.h"
#import <React/UIView+React.h>

@interface RNShareViewClientSdk: UIView {
    NSString *currentUserID;
    MobileRTCActiveShareView *shareView;
}
- (void) setUserID: (NSString *) userID;
@end

@implementation RNShareViewClientSdk

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    shareView = [[MobileRTCActiveShareView alloc] initWithFrame:self.bounds];
    [self addSubview:shareView];
    [shareView setVideoAspect:MobileRTCVideoAspect_PanAndScan];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    shareView.frame = self.bounds;
    if (currentUserID.length > 0) {
        [shareView stopActiveShare];
        NSUInteger userIDInt = [currentUserID integerValue];
        [shareView showActiveShareWithUserID: userIDInt];
    }
}
- (void) setUserID: (NSString *) userID {
    if (userID) {
        if (![currentUserID isEqualToString:userID]) {
            if (userID.length > 0) {
                [shareView stopActiveShare];
                NSUInteger userIDInt = [userID integerValue];
                [shareView showActiveShareWithUserID: userIDInt];
                currentUserID = userID;
            }
            else {
                [shareView stopActiveShare];
                currentUserID = userID;
            }
        }
        else {
            if (currentUserID.length > 0) {
                [shareView stopActiveShare];
                NSUInteger userIDInt = [currentUserID integerValue];
                [shareView showActiveShareWithUserID: userIDInt];
            }
        }
    }
}
- (void) unSubcribeCurrentUser {
    if (currentUserID.length > 0) {
        [shareView stopActiveShare];
        currentUserID = @"";
    }
}
- (void) dealloc {
    [self unSubcribeCurrentUser];
}

@end

@implementation ShareScreenViewManager

RCT_EXPORT_VIEW_PROPERTY(userID, NSString);
RCT_EXPORT_MODULE(RNShareViewClientSdk)

- (UIView *)view
{
    return [RNShareViewClientSdk new];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end

