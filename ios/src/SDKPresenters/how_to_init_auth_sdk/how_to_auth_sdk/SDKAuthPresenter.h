//
//  SDKAuthPresenter.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/15.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKAuthPresenter : NSObject 

// Phunv: Sua ham
//- (void)SDKAuth:(NSString *)jwtToken;
- (void)SDKAuthWithClientKey:(NSString *)clientKey clientSecret: (NSString *) clientSecret;

@end

