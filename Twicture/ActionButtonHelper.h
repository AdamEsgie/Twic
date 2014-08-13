//
//  ActionButtonHelper.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionButtonHelper : NSObject

+(NSDictionary*)actionDictionaryForState:(NSInteger)index;
+(NSDictionary*)leftButtonDictionaryForState:(NSInteger)index;

@end
