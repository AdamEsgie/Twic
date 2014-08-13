//
//  MainViewController.m
//  Twicture
//
//  Created by Adam Salvitti-Gucwa on 8/7/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "MainViewController.h"
#import "CameraScaleHelper.h"
#import "OverlayView.h"
#import "ActionButton.h"
#import "ActionButtonHelper.h"
#import "UserDefaultsHelper.h"
#import "TopBarView.h"
#import "BottomBarView.h"
#import "ColorHelper.h"
#import "InvisibleDragMagicButton.h"
#import "AnimationHelper.h"
#import "PhotoViewController.h"
#import "TwitterRequest.h"
#import <Accounts/Accounts.h>

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ActionButtonDelegate, PhotoButtonDelegate, TwitterDelegate, TopBarDelegate>

@property (nonatomic, strong) UIImagePickerController *cameraController;
@property (nonatomic, strong) OverlayView *overlayView;
@property (nonatomic, strong) UIImage *capturedImage;
@property (nonatomic, strong) PhotoViewController *photoViewController;
@property (nonatomic, strong) NSArray *accounts;
@property NSInteger indexOfSelectedAccount;
@property BOOL animatingDrag;
@property BOOL dragging;

@end

@implementation MainViewController

- (instancetype)initWithFrame:(CGRect)frame andAccounts:(NSArray*)accounts;
{
    self = [super init];
    if (self) {
      self.view.frame = frame;
      self.navigationBarHidden = YES;
      self.accounts = accounts;
      self.indexOfSelectedAccount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
  if (!self.photoViewController) {
    self.photoViewController = [PhotoViewController new];
    self.photoViewController.delegate = self;
    self.photoViewController.view.frame = self.view.bounds;
    self.photoViewController.topBar.delegate = self;
    self.photoViewController.actionButton.delegate = self;
    [self pushViewController:self.photoViewController animated:NO];
  }
  
  if ([self hasAccounts]) {
    self.photoViewController.topBar.accountLabel.text = [self currentAccountName];
    [self.photoViewController.photoView setImage:self.capturedImage];
  } else {
    self.photoViewController.topBar.accountLabel.text = @"No Accounts";
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (self.accounts.count > 0) {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && !self.capturedImage) {
      
      [self showCameraForSource:UIImagePickerControllerSourceTypeCamera animated:NO];
      
    } else if (self.capturedImage) {
      [self.photoViewController animateCommentButton];
    }
  }
}

- (void)showCameraForSource:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)animated
{
//  self.cameraController = nil;
//  [self.overlayView removeFromSuperview];
//  self.overlayView = nil;
  
  if (!self.cameraController) {
    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.sourceType = sourceType;
    self.cameraController.delegate = self;
  }
  if (sourceType == UIImagePickerControllerSourceTypeCamera)
  {
    if (!self.overlayView) {
      self.overlayView = [[OverlayView alloc] initWithFrame:self.view.bounds];
      self.overlayView.topBar.accountLabel.text = [self currentAccountName];
      self.overlayView.topBar.delegate = self;
      self.overlayView.actionButton.delegate = self;
    }
    
    self.cameraController.showsCameraControls = NO;
    self.cameraController.cameraViewTransform = [CameraScaleHelper scaleForFullScreen];
     self.cameraController.cameraOverlayView = self.overlayView;
  
  }
  
  [self presentViewController:self.cameraController animated:animated completion:^{}];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(ACAccount*)currentAccount
{
  return self.accounts[self.indexOfSelectedAccount];
}

-(NSString*)currentAccountName
{
  return [[self currentAccount] accountDescription];
}

- (NSString*)nextAccountName
{
  if ((self.accounts.count - 1) == self.indexOfSelectedAccount) {
    self.indexOfSelectedAccount = 0;
   
  } else {
    self.indexOfSelectedAccount = self.indexOfSelectedAccount + 1;
  }
  return [self currentAccountName];
}

- (BOOL)hasAccounts
{
  return self.accounts.count > 0;
}

#pragma mark - Top Bar Delegate
- (void)changeCamera
{
  if (self.cameraController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
    self.cameraController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
  } else {
    self.cameraController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
  }
}
#pragma mark - ActionButton Delegate
- (void)twicTaken
{
  [self.cameraController takePicture];
}

-(void)sendTwic
{
  TwitterRequest *twitterRequest = [[TwitterRequest alloc] init];
  twitterRequest.delegate = self;
  [twitterRequest postImage:self.capturedImage withStatus:self.photoViewController.textField.text ?: @""];
  [self.photoViewController cleanupTextViewAndDismissKeyboard];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  self.capturedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
  
  if (self.photoViewController) {
    [self.photoViewController centerCommentButtonAnimated:NO];
  }
  
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - PhotoView Delegate

-(void)shouldStartSendingTwic
{
  TwitterRequest *twitterRequest = [[TwitterRequest alloc] init];
  twitterRequest.delegate = self;
  [twitterRequest postImage:self.capturedImage withStatus:self.photoViewController.textField.text ?: @""];
  [self showCameraForSource:UIImagePickerControllerSourceTypeCamera animated:YES];
}
-(void)shouldResetController
{
  [self showCameraForSource:UIImagePickerControllerSourceTypeCamera animated:YES];
}

#pragma mark - Twitter Delegate
-(void)didSuccessfullySendTweet
{
  
}

-(void)errorSendingTweet
{

}
@end
