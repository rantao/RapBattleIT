//
//  StartBattleViewController.m
//  RapBattleIt
//
//  Created by Ran Tao on 10.17.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "StartBattleViewController.h"
#import "MetaDataViewController.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface StartBattleViewController () <AVAudioRecorderDelegate> {
    NSInteger timeLeft;
    BOOL started;
}
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (strong) PFObject *audioObject;
@property (strong) AVAudioRecorder *recorder;
@property (strong) UIButton *recordButton;
@end

@implementation StartBattleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.companies = [NSArray new];
        self.verbs = [NSArray new];
        self.nerdWords = [NSArray new];
        self.companies = @[@"TWILIO",@"BOX",@"AMAZON",@"DROPBOX",@"DUCKSBOARD",@"GOOGLE",@"HEROKU",@"MASHERY",@"PARSE",@"SENDGRID",@"SOUNDCLOUD",@"AZURE"];
        self.verbs = @[@"CODE", @"HACK", @"MERGE", @"FORK", @"DEBUG", @"FETCH", @"POST", @"GET"];
        self.nerdWords = @[@"CLOUD", @"DEVELOPER", @"BIT", @"ARRAY", @"GIT", @"SOURCE", @"SCRIPT", @"OBJECTS", @"SDK", @"API"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rapTopicLabel.font = [UIFont fontWithName:@"Most Wasted" size:30];
    self.topicLabel.font = [UIFont fontWithName:@"Most Wasted" size:24];
    [self setup];

}

-(void) prepareForRecord {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSURL* documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    self.audioURL = [documentDir URLByAppendingPathComponent:@"audio.wav"];
    
    NSDictionary *settings = @{
    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
    AVSampleRateKey : [NSNumber numberWithDouble:48000],
    AVNumberOfChannelsKey : [NSNumber numberWithInt:2]
    };
    
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.audioURL
                                                settings:settings
                                                   error:&error
                     ];
    self.recorder.delegate = self;
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [self.recorder prepareToRecord];
    }

}

-(void)recordTouchDown
{
    NSLog(@"Record touch down!");
    if([self.recorder prepareToRecord]) {
        [self.recorder record];
    }
}

// stop recording
-(void)recordTimerUp
{
    NSLog(@"Record touch up!");
    [self.recorder stop];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder
                          successfully:(BOOL)flag {
    
    [self saveAudioToParse];
}


-(void) setup {
    srand(10);
    NSInteger randomCompanyIndex = rand() % [self.companies count];
    NSInteger randomVerbIndex = rand() % [self.verbs count];
    NSInteger randomNerdWordIndex = arc4random() % [self.nerdWords count];
    NSString *randomCompany = [self.companies objectAtIndex:randomCompanyIndex];
    NSString *randomVerb = [self.verbs objectAtIndex:randomVerbIndex];
    NSString *randomNerdWord = [self.nerdWords objectAtIndex:randomNerdWordIndex];
    self.topicLabel.text = [NSString stringWithFormat:@"%@ %@ %@",randomCompany, randomVerb, randomNerdWord];
    self.countdownLabel.text = @"00:30";
    timeLeft = 30;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) countdownStarted {
    if (timeLeft>=0) {
        if (timeLeft<10) {
            self.countdownLabel.text = [NSString stringWithFormat:@"00:0%d",timeLeft];
        } else {
            self.countdownLabel.text = [NSString stringWithFormat:@"00:%d",timeLeft];

        }
            timeLeft -=1;

    } else {
        [self timerDone];
        [self.countdownTimer invalidate];
        started = NO;
    }
}

-(void) timerDone {
    [self recordTimerUp];
}

-(void) setupTimer {
    timeLeft = 30;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownStarted) userInfo:nil repeats:YES];
}


-(void)saveAudioToParse
{
    NSString *rapPhrase = self.rapTopicLabel.text;
    PFObject *audioObject = [PFObject objectWithClassName:@"audioObject"];
    PFFile *audioFile = [PFFile fileWithName:@"audio.wav" contentsAtPath:[self.audioURL path]];
    
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [audioObject setObject:audioFile forKey:@"audioFile"];
        [audioObject setObject:rapPhrase forKey:@"rapPhrase"];
        //[audioObject setObject:[PFUser currentUser] forKey:@"user"];
        [audioObject saveInBackground];
    }];
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    if (!started) {
        [self setupTimer];
        [self recordTouchDown];

    }
    started = YES;
}
@end
