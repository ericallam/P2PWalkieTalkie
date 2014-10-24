//
//  Multipeer.h
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol MultipeerDelegate <NSObject>

@end


@interface MultipeerManager : NSObject

@property (readonly) MCPeerID *localPeerID;
@property (weak, nonatomic) id<MultipeerDelegate> delegate;
@property (readonly, nonatomic) MCSession *session;

+ (instancetype)sharedManager;
//- (void)startAdvertising;
//- (void)stopAdvertising;

@end

FOUNDATION_EXPORT NSString *MultipeerServiceType;
