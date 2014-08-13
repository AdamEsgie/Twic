//
//  OverlayView.m
//  Twicture
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "OverlayView.h"
#import "ActionButton.h"
#import "TopBarView.h"
#import "BottomBarView.h"
#import "UserDefaultsHelper.h"
#import "ActionButtonHelper.h"

@interface OverlayView ()

@end

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
      [self setup];
    }
    return self;
}

-(void)setup
{
  self.topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.width, buttonSize)];
  [self.topBar.leftButton setImage:[ActionButtonHelper leftButtonDictionaryForState:cameraRollState][@"image"] forState:UIControlStateNormal];
  [self.topBar.leftButton addTarget:self.topBar action:NSSelectorFromString([ActionButtonHelper leftButtonDictionaryForState:cameraRollState][@"selector"]) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.topBar];
  
  self.bottomBar = [[BottomBarView alloc] initWithFrame:CGRectMake(0, self.height-buttonSize, self.width, buttonSize)];
  [self.bottomBar addActionButton];
  self.actionButton = self.bottomBar.actionButton;
  [self addSubview:self.bottomBar];
}
@end
