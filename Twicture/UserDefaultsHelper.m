//
//  UserDefaultsHelper.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "UserDefaultsHelper.h"

NSString* const UserDefaultsHelperSettingRunMoreThanOnce = @"isRunMoreThanOnce";
NSString* const UserDefaultsHelperSettingLastAccount = @"lastAccount";

@implementation UserDefaultsHelper

+ (void) setup
{
  BOOL isRunMoreThanOnce = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsHelperSettingRunMoreThanOnce];
  if(!isRunMoreThanOnce){
  
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaultsHelperSettingRunMoreThanOnce];
  
  }
}

+ (void) sync
{
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)lastViewedAccount
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsHelperSettingLastAccount];;
}

+ (void)setLastViewedAccount:(ACAccount*)account;
{
    [[NSUserDefaults standardUserDefaults] setObject:[account accountDescription] forKey:UserDefaultsHelperSettingLastAccount];
}
@end
