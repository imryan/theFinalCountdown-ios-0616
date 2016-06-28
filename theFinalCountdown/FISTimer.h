//
//  FISTimer.h
//  theFinalCountdown
//
//  Created by Ryan Cohen on 6/28/16.
//  Copyright © 2016 The Flatiron School. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FISTimerDelegate <NSObject>

- (void)timerDidTick;
- (void)timerDidFinish;

@end

@interface FISTimer : NSObject <FISTimerDelegate>

@property (nonatomic, readonly) NSUInteger hours;
@property (nonatomic, readonly) NSUInteger minutes;
@property (nonatomic, readonly) NSUInteger seconds;

@property (nonatomic, readonly) BOOL paused;

@property (nonatomic, strong) id<FISTimerDelegate> delegate;

- (instancetype)initWithTimeInterval:(NSTimeInterval)time;

- (NSString *)formattedTime;

- (void)start;
- (void)pause;
- (void)cancel;

@end
