//
//  ColorHelper.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "ColorHelper.h"
#import "UserDefaultsHelper.h"

@implementation ColorHelper

+(UIColor*)colorForOffset:(CGFloat)offset
{
  CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
  CGFloat middle = screenWidth/2;
  CGFloat trigger = screenWidth/3;
  
  CGFloat percentageToTrigger = ABS(middle-offset)/trigger;
  
  CGFloat yred = 0.0, ygreen = 0.0, yblue = 0.0, yalpha =0.0;
  [YellowButtonColor getRed:&yred green:&ygreen blue:&yblue alpha:&yalpha];
  
  
  if (offset > middle) {
   
    CGFloat gred = 0.0, ggreen = 0.0, gblue = 0.0, galpha =0.0;
    [GreenButtonColor getRed:&gred green:&ggreen blue:&gblue alpha:&galpha];
    
    return [UIColor colorWithRed:yred+((gred-yred)*percentageToTrigger) green:ygreen+((ggreen-ygreen)*percentageToTrigger) blue:yblue+((gblue-yblue)*percentageToTrigger) alpha:1.0];
  
  } else if (offset < middle) {
    
    CGFloat rred = 0.0, rgreen = 0.0, rblue = 0.0, ralpha =0.0;
    [RedButtonColor getRed:&rred green:&rgreen blue:&rblue alpha:&ralpha];
    
    return [UIColor colorWithRed:yred+((rred-yred)*percentageToTrigger) green:ygreen+((rgreen-ygreen)*percentageToTrigger) blue:yblue+((rblue-yblue)*percentageToTrigger) alpha:1.0];
  }
  
  return YellowButtonColor;
}

+(CGFloat)percentageToTriggerForOffset:(CGFloat)offset
{
  
  CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
  CGFloat middle = screenWidth/2;
  CGFloat trigger = screenWidth/3;
  
  return ABS(middle-offset)/trigger;
}

@end
