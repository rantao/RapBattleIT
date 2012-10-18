//
//  RecordingViewController.m
//  SoundRecorder
//
//  Created by Stephanie Shupe on 10/17/12.
//  Copyright (c) 2012 shupeCreations. All rights reserved.
//

#import "RecordingViewController.h"
#import "MetaDataViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordingViewController ()<AVAudioRecorderDelegate>
@property (strong) PFObject *audioObject;
@property (strong) AVAudioRecorder *recorder;
@property (strong) UIButton *recordButton;

@end

@implementation RecordingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Recording things
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

// start recording
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder
                          successfully:(BOOL)flag {
    
    MetaDataViewController *metaDataVC = [MetaDataViewController new];
    metaDataVC.audioURL = self.audioURL;
    [self.navigationController pushViewController:metaDataVC animated:YES];
}
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 @end
 */
@end
