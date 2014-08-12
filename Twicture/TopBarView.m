//
//  TopBarView.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "TopBarView.h"
#import "UserDefaultsHelper.h"

@implementation TopBarView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
      self.backgroundColor = YellowButtonColor;
      [self addButtons];
    }
    return self;
}

- (void)addButtons
{
 
  self.frontCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - self.height, 0, buttonSize, buttonSize)];
  [self.frontCameraButton addTarget:self action:@selector(frontCameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self.frontCameraButton setImage:[UIImage imageNamed:@"frontCameraIcon"] forState:UIControlStateNormal];
  [self addSubview:self.frontCameraButton];
  
  self.infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
  [self.infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self.infoButton setImage:[UIImage imageNamed:@"infoIcon"] forState:UIControlStateNormal];
  [self addSubview:self.infoButton];
  
  self.accountButton = [[UIButton alloc] initWithFrame:CGRectMake(self.infoButton.right, 0, self.width - self.infoButton.width - self.frontCameraButton.width, self.height)];
  [self.accountButton addTarget:self action:@selector(accountButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.accountButton];
  
  self.accountLabel = [[UILabel alloc] initWithFrame:self.accountButton.frame];
  self.accountLabel.font = DefaultTitleFont;
  self.accountLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:self.accountLabel];
}

-(IBAction)infoButtonTapped:(id)sender
{
  
}

-(IBAction)frontCameraButtonTapped:(id)sender
{
  [self.delegate changeCamera];
}

-(IBAction)accountButtonTapped:(id)sender
{
  NSString *nextAccountName = [self.delegate nextAccountName];
  self.accountLabel.text = nextAccountName;
}
@end
