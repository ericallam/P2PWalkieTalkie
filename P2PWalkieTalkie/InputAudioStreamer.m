//
//  InputAudioStream.m
//  P2PWalkieTalkie
//
//  Created by Eric Allam on 24/10/2014.
//  Copyright (c) 2014 Eric Allam. All rights reserved.
//

#import "InputAudioStreamer.h"

@interface InputAudioStreamer () <NSStreamDelegate>
@property (nonatomic, strong) NSInputStream *stream;
@end

@implementation InputAudioStreamer

- (instancetype)initWithStream:(NSInputStream *)stream
{
    if (self = [super init]) {
        _stream = stream;
        _stream.delegate = self;
    }
    
    return self;
}

- (void)start
{
    [self.stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.stream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
