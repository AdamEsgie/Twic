//
//  ColorHelper.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorHelper : NSObject

+(UIColor*)colorForOffset:(CGFloat)offset;
+(CGFloat)percentageToTriggerForOffset:(CGFloat)offset;

@end
