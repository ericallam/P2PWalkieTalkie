//
//  AppDelegate.m
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import "AppDelegate.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString * const XXServiceType = @"com.CmdR.WalkieTalkie";

@interface AppDelegate () <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
@property (strong, nonatomic) MCPeerID *localPeerID;
@property (strong, atomic) NSMutableArray *mutableBlockedPeers;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    MCNearbyServiceAdvertiser *advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                      discoveryInfo:nil
                                        serviceType:XXServiceType];
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
    
    return YES;
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
        MCSession *session = [[MCSession alloc] initWithPeer:self.localPeerID
                                            securityIdentity:nil
                                        encryptionPreference:MCEncryptionRequired];
        session.delegate = self;
        
        invitationHandler(YES, session);
    }]];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
