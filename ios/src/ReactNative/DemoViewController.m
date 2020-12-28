//
//  DemoViewController.m
//  MobileRTCSample
//
//  Created by Phu on 9/14/20.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "DemoViewController.h"
#import "SDKAuthPresenter.h"
#import "SDKInitPresenter.h"
#import "RNMeetingCenter.h"
#import "RNZoomView.h"

@interface DemoViewController ()

@property (nonatomic, strong) RNZoomView *rnZoomView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leave" style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftBarBtn)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:self action:@selector(handleRightBarBtn)];
    [RNMeetingCenter shared];
}
- (void) handleRightBarBtn {
    if (!self.rnZoomView) {
        self.rnZoomView = [[RNZoomView alloc] init];        
        [self.view addSubview:self.rnZoomView];
        self.rnZoomView.frame = self.view.bounds;
    }
}

- (void) handleLeftBarBtn {
    if (self.rnZoomView) {
        [self.rnZoomView removeFromSuperview];
        self.rnZoomView = nil;
        [[RNMeetingCenter shared] leaveCurrentMeeting];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
