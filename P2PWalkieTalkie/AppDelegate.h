//
//  AppDelegate.h
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Multipeer.h"

@class MCPeerID, MCSession;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Multipeer *multipeer;

@end

