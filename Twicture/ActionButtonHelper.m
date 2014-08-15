//
//  ActionButtonHelper.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "ActionButtonHelper.h"
#import "ActionButton.h"

@implementation ActionButtonHelper

+(NSDictionary*)actionDictionaryForState:(NSInteger)index
{
  NSArray *actionData = @[@{@"name":@"photo",
                            @"selector":NSStringFromSelector(@selector(takePhotoTapped:)),
                            @"image":[UIImage imageNamed:@"cameraIcon"]
                            },
                          @{@"name":@"comment",
                            @"selector":NSStringFromSelector(@selector(commentTapped:)),
                            @"image":[UIImage imageNamed:@"commentIcon"]
                            },
                          @{@"name":@"send",
                            @"selector":NSStringFromSelector(@selector(sendTapped:)),
                            @"image":[UIImage imageNamed:@"checkIcon"]
                            },
                          @{@"name":@"cancel",
                            @"selector":NSStringFromSelector(@selector(cancelTapped:)),
                            @"image":[UIImage imageNamed:@"cancelIcon"]
                            }
                          ];
  return actionData[index];
}

+(NSDictionary*)leftButtonDictionaryForState:(NSInteger)index
{
  NSArray *leftButtonData = @[@{@"name":@"photo",
                            @"selector":NSStringFromSelector(@selector(rollTapped:)),
                            @"image":[UIImage imageNamed:@"rollIcon"]
                            },
                          @{@"name":@"info",
                            @"selector":NSStringFromSelector(@selector(infoTapped:)),
                            @"image":[UIImage imageNamed:@"infoIcon"]
                            },
                            @{@"name":@"cancel",
                              @"selector":NSStringFromSelector(@selector(cancelCameraRollTapped:)),
                              @"image":[UIImage imageNamed:@"cancelIcon"]
                              },
                          ];
  return leftButtonData[index];
}

@end
