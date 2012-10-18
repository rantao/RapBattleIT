//
//  StartBattleViewController.h
//  RapBattleIt
//
//  Created by Ran Tao on 10.17.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartBattleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *rapTopicLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *beatSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) NSArray *companies;
@property (strong, nonatomic) NSArray *verbs;
@property (strong, nonatomic) NSArray *nerdWords;
@property (strong) NSURL *audioURL;

- (IBAction)beatChanged:(UISegmentedControl *)sender;

- (IBAction)startButtonPressed:(UIButton *)sender;

@end
