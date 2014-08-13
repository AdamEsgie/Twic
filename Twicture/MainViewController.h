//
//  MainViewController.h
//  Twicture
//
//  Created by Adam Salvitti-Gucwa on 8/7/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterRequest;

@interface MainViewController : UINavigationController

@property (nonatomic, strong, readonly) NSArray *accounts;

- (instancetype)initWithFrame:(CGRect)frame andAccounts:(NSArray*)accounts;

@end
