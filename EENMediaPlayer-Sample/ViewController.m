//
//  ViewController.m
//  TestPlayer
//
//  Created by Greg Slomin on 6/1/16.
//  Copyright © 2016 Eagle Eye Networks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) EENMediaPlayer *player;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *start;
@property (nonatomic, retain) NSString *end;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) setupLive {
    self.start = [NSString stringWithFormat:@"stream_%ld", (long)[NSDate timeIntervalSinceReferenceDate]*100];
    self.end = @"+3000000";
    [self.player setFrame:self.view.frame];
    [self.view addSubview:self.player];
}

-(void) setupHistorical {
    self.start = @"20170804212823.352";
    self.end = @"20170804213113.291";
    [self.player setFrame:self.view.frame];
    [self.view addSubview:self.player];
}

-(void) setupInline {
    self.start = [NSString stringWithFormat:@"stream_%ld", (long)[NSDate timeIntervalSinceReferenceDate]*100];
    self.end = @"+3000000";
    
    // This removes the title bar, duration, and timestamp at the top of the screen.
    [self.player enableControlBar:NO];
    
    UIView *view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view];
    
    // Begin Constraints
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[view]-100-|" options:kNilOptions metrics:nil views:@{@"view":view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[view]-100-|" options:kNilOptions metrics:nil views:@{@"view":view}]];
    
    [view addSubview:self.player];
    
    [self.player setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.player}]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.player}]];
    
    //end constraints
}

- (void)viewWillAppear:(BOOL)animated {
    self.player = [EENMediaPlayer new];
    self.baseURL = [NSString stringWithFormat:@"https://%@.eagleeyenetworks.com", _cluster];
    
    // Change this to test functionality of historical and inline video.
    int mode = 0;
    switch (mode) {
        case 0:
            [self setupLive];
            break;
    
        case 1:
            [self setupHistorical];
            break;
    
        case 2:
            [self setupInline];
            break;
    }
    
    [self.player startStream:self.esn baseURL:self.baseURL withTitle:@"Camera Name" startTime:self.start endTime:self.end dateFormat:@"yyyy-MM-dd HH:mm:ssZZZZZ" andTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [self.player setDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)donePressed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_player removeFromSuperview];
        [_player setDelegate:nil];
        _player = nil;
    });
}

-(void)headerReceived:(NSData *)header withStartTime:(NSDate *)date {
    NSLog(@"FLV header parsed");
}

-(void)bufferingStarted {
    NSLog(@"Buffering started");
}

-(void)requestStarted {
	NSLog(@"Started");
}
-(void)playbackDidStart {
	NSLog(@"DidStart");
}

-(void)connectionClosedWithError:(NSError*)error {
	NSLog(@"Error:%@", error);
}

@end
