//
//  MetaDataViewController.m
//  SoundRecorder
//
//  Created by Stephanie Shupe on 10/17/12.
//  Copyright (c) 2012 shupeCreations. All rights reserved.
//

#import "MetaDataViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MetaDataViewController () <UITextFieldDelegate, AVAudioPlayerDelegate>
@property (strong) AVAudioPlayer *player;
@end

@implementation MetaDataViewController

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
	// Do any additional setup after loading the view.
    
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:&error];
    self.player.delegate = self;
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [self.player prepareToPlay];
    }

}

-(void)playButtonPressed
{
    if (!self.player.playing)
        [self.player play];
    else
        [self.player stop];
}

-(void)saveAudioToParse
{
    PFObject *audioObject = [PFObject objectWithClassName:@"audioObject"];
    PFFile *audioFile = [PFFile fileWithName:@"audio.wav" contentsAtPath:[self.audioURL path]];
    
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [audioObject setObject:audioFile forKey:@"audioFile"];
        // [audioObject setObject:[PFUser currentUser] forKey:@"user"];
        if (self.titleField.text) {
            [audioObject setObject:self.titleField.text forKey:@"title"];
        } else {
            [audioObject setObject:[[NSDate date] description] forKey:@"title"];
        }
        [audioObject saveInBackground];
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
