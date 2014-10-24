//
//  OutputAudioStreamer.h
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutputAudioStreamer : NSObject

- (instancetype)initWithStream:(NSOutputStream *)stream;

- (void)start;

@end
