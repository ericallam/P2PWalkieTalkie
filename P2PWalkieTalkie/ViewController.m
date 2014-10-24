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

@interface ViewController () <MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findNearby:(id)sender {
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:appDel.multipeer.localPeerID serviceType:MultipeerServiceType];
    browser.delegate = self;
    
    MCBrowserViewController *browserViewController =
    [[MCBrowserViewController alloc] initWithBrowser:browser
                                             session:appDel.multipeer.session];
    browserViewController.delegate = self;
    [self presentViewController:browserViewController
                       animated:YES
                     completion:
     ^{
         [browser startBrowsingForPeers];
     }];
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Found Peer: %@, discovery: %@", peerID, info);
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Lost Peer: %@", peerID);
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController.browser stopBrowsingForPeers];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [browserViewController.browser stopBrowsingForPeers];
    }];
}

@end
