//
//  PhotoViewController.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBarView, BottomBarView;

@protocol PhotoButtonDelegate <NSObject>

-(void)shouldStartSendingTwic;
-(void)shouldCancelTwic;

@end

@interface PhotoViewController : UIViewController

@property (nonatomic,weak) id <PhotoButtonDelegate> delegate;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) BottomBarView *bottomBar;
@property (nonatomic, strong) TopBarView *topBar;

-(void)animateCommentButton;
-(void)centerCommentButtonAnimated:(BOOL)animated;

@end
