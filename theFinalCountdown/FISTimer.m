//
//  FISTimer.m
//  theFinalCountdown
//
//  Created by Ryan Cohen on 6/28/16.
//  Copyright © 2016 The Flatiron School. All rights reserved.
//

#import "FISTimer.h"

@interface FISTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, strong) NSString *formattedTime;
@property (nonatomic, assign) NSUInteger ticks;

@property (nonatomic, assign) NSUInteger hours;
@property (nonatomic, assign) NSUInteger minutes;
@property (nonatomic, assign) NSUInteger seconds;

@property (nonatomic, assign) BOOL paused;

@end

@implementation FISTimer

#pragma mark - Init

- (instancetype)init {
    return [self initWithTimeInterval:0];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)time {
    self = [super init];
    if (self) {
        _formattedTime = @"00:00:00";
        _time = time;
        _paused = NO;
        
        _hours = 0;
        _minutes = 0;
        _seconds = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDidTick) userInfo:nil repeats:YES];
        _ticks = (NSUInteger)time;
    }
    
    return self;
}

#pragma mark - Delegate

- (void)timerDidTick {
    if (!self.paused) {
        self.ticks--;
        
        self.hours = (self.ticks / 3600);
        self.minutes = ((self.ticks % 3600) / 60);
        self.seconds = (self.ticks % 60);
        
        if (self.ticks == 0) {
            [self timerDidFinish];
        }
        
        [self.delegate timerDidTick];
    }
}

- (void)timerDidFinish {
    [self cancel];
    [self.delegate timerDidFinish];
}

#pragma mark - Methods

- (void)start {
    if (!self.paused) {
        [self.timer fire];
        
        self.paused = NO;
    } else {
        self.paused = NO;
        [self.delegate timerDidTick];
    }
}

- (void)pause {
    if (self.paused) {
        return;
    } else {
        self.paused = YES;
    }
}

- (void)cancel {
    [self.timer invalidate];
    
    self.paused = NO;
    
    self.ticks = 0;
    
    self.hours = 0;
    self.minutes = 0;
    self.seconds = 0;
}

- (NSString *)formattedTime {
    return [NSString stringWithFormat:@"%lu:%lu:%lu", self.hours, self.minutes, self.seconds];
}

@end
