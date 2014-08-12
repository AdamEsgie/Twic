//
//  BottomBarView.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionButton.h"

@interface BottomBarView : UIView

@property (nonatomic, strong) ActionButton *actionButton;

- (void)addActionButton;

@end
