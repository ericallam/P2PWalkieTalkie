//
//  Multipeer.m
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import "Multipeer.h"
#import "AppDelegate.h"

NSString *MultipeerServiceType = @"comcmdr-wt";

@interface Multipeer () <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate>

@property (strong, nonatomic) MCPeerID *localPeerID;
@property (strong, nonatomic) MCAdvertiserAssistant *advertiserAssistant;
@property (strong, atomic) NSMutableArray *mutableBlockedPeers;
@property (strong, nonatomic) MCSession *session;
@end

@implementation Multipeer

- (instancetype)init
{
    if (self = [super init]) {
        _localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        
        _session = [[MCSession alloc] initWithPeer:_localPeerID
                                            securityIdentity:nil
                                        encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
        
        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:MultipeerServiceType discoveryInfo:nil session:_session];
        
        [_advertiserAssistant start];
    }
    
    return self;
}

- (void)dealloc
{
    [_advertiserAssistant stop];
    [_session disconnect];
}

- (void)findNearbyFromViewController:(UIViewController *)controller
{
    MCBrowserViewController *browserViewController =
    [[MCBrowserViewController alloc] initWithServiceType:MultipeerServiceType session:self.session];
    browserViewController.delegate = self;
    
    [controller presentViewController:browserViewController
                       animated:YES
                     completion:nil];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    if ([self.mutableBlockedPeers containsObject:peerID]) {
        invitationHandler(NO, nil);
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Received Invitation from %@", @"Received Invitation from {Peer}"), peerID.displayName] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reject", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        invitationHandler(NO, nil);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Block", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self.mutableBlockedPeers addObject:peerID];
        
        invitationHandler(NO, nil);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Accept", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        invitationHandler(YES, self.session);
    }]];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error;
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [browserViewController.browser stopBrowsingForPeers];
    }];
}

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;
{
    return YES;
}


@end
