//
//  OverlayView.h
//  Twicture
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionButton, BottomBarView, TopBarView;

@interface OverlayView : UIView

@property (nonatomic, strong) ActionButton *actionButton;

@property (nonatomic, strong) BottomBarView *bottomBar;
@property (nonatomic, strong) TopBarView *topBar;

@end
