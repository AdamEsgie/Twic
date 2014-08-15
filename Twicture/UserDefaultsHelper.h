//
//  UserDefaultsHelper.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

typedef NS_ENUM(NSInteger, ActionButtonState)
{
  photoState = 0,
  commentState = 1,
  sendState = 2,
  cancelState = 3,
};

typedef NS_ENUM(NSInteger, LeftButtonState)
{
  cameraRollState = 0,
  infoState = 1,
  cancelCameraRollState = 2,
  frontCameraState = 3,
  filterState = 4,
};

#define YellowButtonColor [UIColor colorWithRed:255/255.0f green:203/255.0f blue:1/255.0f alpha:1.00]
#define RedButtonColor [UIColor colorWithRed:255/255.0f green:86/255.0f blue:1/255.0f alpha:1.00]
#define GreenButtonColor [UIColor colorWithRed:0/255.0f green:206/255.0f blue:15/255.0f alpha:1.00]

#define DefaultTitleFont [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:20.0f]
#define DefaultTextFieldFont [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:20.0f]

static const CGFloat buttonSize = 64;

extern NSString* const UserDefaultsHelperSettingRunMoreThanOnce;
extern NSString* const UserDefaultsHelperSettingLastAccount;

@interface UserDefaultsHelper : NSObject

+ (void)setup;
+ (id)lastViewedAccount;
+ (void)setLastViewedAccount:(ACAccount*)account;

@end
