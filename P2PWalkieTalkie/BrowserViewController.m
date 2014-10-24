//
//  BrowserViewController.m
//  P2PWalkieTalkie
//
//  Created by Kyle McAlpine on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import "BrowserViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MultipeerManager.h"

@interface BrowserViewController ()

@property (strong, nonatomic) MCBrowserViewController *browserVC;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MultipeerManager *manager = [MultipeerManager sharedManager];
    self.browserVC = [[MCBrowserViewController alloc]initWithServiceType:MultipeerServiceType session:manager.session];
    self.browserVC.view.frame = self.view.frame;
    [self.view addSubview:self.browserVC.view];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
