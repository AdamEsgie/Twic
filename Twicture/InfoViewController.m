//
//  InfoViewController.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/17/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "InfoViewController.h"
#import "TopBarView.h"
#import "UserDefaultsHelper.h"
#import "ActionButtonHelper.h"

@interface InfoViewController ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *urlButton;

@end

@implementation InfoViewController

- (id)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, buttonSize)];
  [self.topBar.leftButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:cancelCameraRollState][@"image"] forState:UIControlStateNormal];
  [self.topBar.leftButton addTarget:self.topBar action:NSSelectorFromString([ActionButtonHelper topBarButtonDictionaryForState:cancelCameraRollState][@"selector"]) forControlEvents:UIControlEventTouchUpInside];
  self.topBar.accountLabel.text = @"Info";
  [self.topBar.rightButton removeFromSuperview];
  self.topBar.rightButton = nil;
  [self.view addSubview:self.topBar];
  
  self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topBar.bottom, self.topBar.width, self.view.height - self.topBar.height)];
  self.infoLabel.backgroundColor = [UIColor whiteColor];
  self.infoLabel.textAlignment = NSTextAlignmentCenter;
  self.infoLabel.numberOfLines = 0;
  self.infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.infoLabel.text = @"made with <3\nby @adamesgie";
  self.infoLabel.font = DefaultTextFieldLargeFont;
  [self.view addSubview:self.infoLabel];
  
  self.urlButton = [UIButton new];
  self.urlButton.frame = self.infoLabel.frame;
  [self.urlButton addTarget:self action:@selector(sayHelloTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.urlButton];
}

-(IBAction)sayHelloTapped:(id)sender
{
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/adamesgie"]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
