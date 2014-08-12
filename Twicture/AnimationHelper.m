//
//  AnimationHelper.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

+(CGAffineTransform)scaleShrinkView:(UIView*)view
{
  return CGAffineTransformScale(view.transform, 0.01, 0.01);
}
+(CGAffineTransform)scaleExpandView:(UIView*)view
{
  return CGAffineTransformScale(view.transform, 100.0, 100.0);
}

@end
