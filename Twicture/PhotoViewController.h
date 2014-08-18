//
//  PhotoViewController.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBarView, BottomBarView, ActionButton;

@protocol PhotoButtonDelegate <NSObject>

-(void)shouldStartSendingTwic;
-(void)shouldResetController;
- (BOOL)hasAccounts;
-(BOOL)isInternetAvailable;

@end

@interface PhotoViewController : UIViewController

@property (nonatomic,weak) id <PhotoButtonDelegate> delegate;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) BottomBarView *bottomBar;
@property (nonatomic, strong) TopBarView *topBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) ActionButton *actionButton;
@property (nonatomic, strong) UIImage *originalImage;
@property BOOL isInErrorState;
@property BOOL didCancelPost;

-(void)animateButtons;
-(void)centerCommentButtonAnimated:(BOOL)animated;
-(void)cleanupTextViewAndDismissKeyboard;
-(void)cleanupTextViewAndDismissKeyboardAfterNoInternetConnection;
@end
