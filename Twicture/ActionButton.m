//
//  ActionButton.m
//  Twicture
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "ActionButton.h"
#import "UserDefaultsHelper.h"
#import "ActionButtonHelper.h"

@interface ActionButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation ActionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
      [self addTarget:self action:@selector(takePhotoTapped:) forControlEvents:UIControlEventTouchUpInside];
      [self setImage:[UIImage imageNamed:@"defaultOval"] forState:UIControlStateNormal];
      [self addSubview:[self setupActionView]];
    }
    return self;
}
-(UIImageView*)setupActionView
{
  UIImage *photoImage = [ActionButtonHelper actionDictionaryForState:photoState][@"image"];
  self.actionView = [[UIImageView alloc] initWithImage:photoImage];
  self.actionView.size = CGSizeMake(photoImage.size.height, photoImage.size.width);
  return self.actionView;
}

-(IBAction)takePhotoTapped:(id)sender
{
  if ([self.delegate isCameraAvailable]) {
    [self.delegate twicTaken];
  }
}

-(IBAction)sendTapped:(id)sender
{
  if (![self.delegate isInternetAvailable]) {
    [self.actionView setImage:[ActionButtonHelper actionDictionaryForState:cancelState][@"image"]];
  }
  [self.delegate sendTwic];
}

-(void)clearTargetsAndActions
{
  [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

-(void)addTargetAtIndex:(NSInteger)index
{
  SEL selector = NSSelectorFromString([ActionButtonHelper actionDictionaryForState:index][@"selector"]);
  [self addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}
@end
