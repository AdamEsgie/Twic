//
//  AnimationHelper.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationHelper : NSObject

+(CGAffineTransform)scaleShrinkView:(UIView*)view;
+(CGAffineTransform)scaleExpandView:(UIView*)view;

@end
