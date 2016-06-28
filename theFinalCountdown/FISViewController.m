//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISTimer.h"

#import "FISViewController.h"

@interface FISViewController ()

@property (nonatomic, strong) FISTimer *timer;

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *pauseButton;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign) NSTimeInterval countdownTime;

@property (nonatomic, weak) NSLayoutConstraint *timeLabelTopConstraint;

- (IBAction)start:(id)sender;
- (IBAction)pause:(id)sender;

@end

@implementation FISViewController

#pragma mark - Actions

- (IBAction)start:(id)sender {
    if (![self.startButton.titleLabel.text isEqualToString:@"Cancel"]) {
        [self.startButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        self.timeLabel.alpha = 0.f;
        self.timeLabel.hidden = NO;
        self.pauseButton.enabled = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.datePicker.alpha = 0.f;
            self.timeLabel.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            if (finished) {
                self.datePicker.hidden = YES;
                
                self.timer = [[FISTimer alloc] initWithTimeInterval:self.countdownTime];
                self.timer.delegate = self;
                
                [self.timer start];
            }
        }];
        
    } else {
        [self.timer cancel];
        
        self.timeLabel.text = @"00:00:00";
        
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        self.datePicker.hidden = NO;
        self.timeLabel.hidden = YES;
        self.pauseButton.enabled = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.datePicker.alpha = 1.f;
        }];
    }
}

- (IBAction)pause:(id)sender {
    if (!self.timer.paused) {
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self.timer pause];
    } else {
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.timer start];
    }
}

#pragma mark - Time

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"HH:mm:ss";
    });
    
    return formatter;
}

- (void)pickedTime:(UIDatePicker *)sender {
    NSString *date = [[FISViewController dateFormatter] stringFromDate:sender.date];
    
    NSInteger hours = [date substringToIndex:2].integerValue;
    NSInteger minutes = [date substringFromIndex:3].integerValue;
    
    self.countdownTime = (hours * 3600) + (minutes * 60);
}

#pragma mark - FISTimerDelegate

- (void)timerDidTick {
    self.timeLabel.text = [self.timer formattedTime];
}

- (void)timerDidFinish {
    self.timer = nil;
    self.timeLabel.hidden = YES;
    
    self.datePicker.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
       self.datePicker.alpha = 1.f;
    }];
    
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    self.pauseButton.enabled = NO;
}

#pragma mark - Layout

- (void)setupView {
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.layer.borderWidth = 0.7f;
    self.datePicker.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.datePicker addTarget:self action:@selector(pickedTime:) forControlEvents:UIControlEventValueChanged];
    
    self.timeLabel.layer.borderWidth = 0.7f;
    self.timeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.view removeConstraints:self.view.constraints];
    
    [self.datePicker.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:64.f].active = YES;
    [self.datePicker.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.datePicker.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.timeLabelTopConstraint = [self.timeLabel.topAnchor constraintEqualToAnchor:self.datePicker.topAnchor];
    self.timeLabelTopConstraint.active = YES;
    
    [self.timeLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.timeLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.timeLabel.bottomAnchor constraintEqualToAnchor:self.datePicker.bottomAnchor].active = YES;
    
    [self.startButton.topAnchor constraintEqualToAnchor:self.datePicker.bottomAnchor constant:100.f].active = YES;
    [self.startButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:64.f].active = YES;
    
    [self.pauseButton.topAnchor constraintEqualToAnchor:self.datePicker.bottomAnchor constant:100.f].active = YES;
    [self.pauseButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-64.f].active = YES;
}

- (void)hideViewElements:(BOOL)hide {
    self.datePicker.hidden = hide;
    self.startButton.hidden = hide;
    self.pauseButton.hidden = hide;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        [self hideViewElements:YES];
        
        self.timeLabelTopConstraint.constant = 20.f;
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:128.f];
        
        if (self.timeLabel.hidden) {
            self.timeLabel.text = @"00:00:00";
            self.timeLabel.hidden = NO;
        }
        
    } else {
        [self hideViewElements:NO];
        
        self.timeLabelTopConstraint.constant = 0.f;
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:64.f];
    }
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.timeLabel.hidden = YES;
    self.countdownTime = 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
