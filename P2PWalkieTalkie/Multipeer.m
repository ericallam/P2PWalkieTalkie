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

@interface Multipeer () <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
@property (strong, nonatomic) MCPeerID *localPeerID;
@property (strong, atomic) NSMutableArray *mutableBlockedPeers;
@end

@implementation Multipeer

- (instancetype)init
{
    if (self = [super init]) {
        _localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        
        _session = [[MCSession alloc] initWithPeer:_localPeerID
                                            securityIdentity:nil
                                        encryptionPreference:MCEncryptionRequired];
        _session.delegate = self;
    }
    
    return self;
}

- (void)startAdvertising
{
    MCNearbyServiceAdvertiser *advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                      discoveryInfo:nil
                                        serviceType:MultipeerServiceType];
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
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

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

@end
