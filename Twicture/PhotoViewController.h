//
//  PhotoViewController.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBarView, BottomBarView, ActionButton, ACAccount, MainViewController;

@protocol PhotoButtonDelegate <NSObject>

-(void)shouldStartSendingTwic;
-(void)shouldResetController;
-(BOOL)hasAccounts;
-(BOOL)isInternetAvailable;
-(NSString*)currentAccountName;
-(ACAccount*)currentAccount;
-(void)getDelegateForActionButton:(ActionButton*)button;
-(void)getDelegateForTopBar:(TopBarView*)topBar;

@end

@interface PhotoViewController : UIViewController

@property (nonatomic,weak) id <PhotoButtonDelegate> delegate;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) BottomBarView *bottomBar;
@property (nonatomic, strong) TopBarView *topBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) ActionButton *actionButton;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSData *twicData;

@property BOOL isInErrorState;
@property BOOL didCancelPost;
@property NSInteger linkLength;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setup;
-(void)animateButtons;
-(void)centerCommentButtonAnimated:(BOOL)animated;
-(void)cleanupTextViewAndDismissKeyboard;
-(void)cleanupTextViewAndDismissKeyboardAfterNoInternetConnection;
@end
