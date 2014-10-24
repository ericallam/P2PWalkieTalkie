//
//  ViewController.m
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Multipeer.h"

@interface ViewController ()
@property (strong, nonatomic) Multipeer *multipeer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.multipeer = appDel.multipeer;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findNearby:(id)sender {
    [self.multipeer findNearbyFromViewController:self];
}

@end
