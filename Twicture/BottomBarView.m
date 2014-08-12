//
//  BottomBarView.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "BottomBarView.h"
#import "UserDefaultsHelper.h"

@implementation BottomBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
      self.backgroundColor = YellowButtonColor;
    }
    return self;
}

- (void)addActionButton
{
  self.actionButton = [[ActionButton alloc] initWithFrame:CGRectMake(self.width/2 - buttonSize/2, self.height - buttonSize, buttonSize, buttonSize)];
  [self addSubview:self.actionButton];
}

@end
