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
#import "CameraRollViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Reachability.h"
#import "ProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "InfoViewController.h"

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ActionButtonDelegate, PhotoButtonDelegate, TwitterDelegate, TopBarDelegate, CameraRollDelegate>

@property (nonatomic, strong) UIImagePickerController *cameraController;
@property (nonatomic, strong) OverlayView *overlayView;
@property (nonatomic, strong) UIImage *capturedImage;
@property (nonatomic, strong) CameraRollViewController *rollViewController;
@property (nonatomic, strong) PhotoViewController *photoViewController;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) InfoViewController *infoController;
@property NSInteger indexOfSelectedAccount;
@property BOOL shouldShowCameraRoll;
@property BOOL isPresentingInfoController;
@property BOOL animatingDrag;
@property BOOL dragging;
@property BOOL isInternetReachable;
@property BOOL isCameraReady;

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

- (void)dealloc
{
  NSLog(@"dealloc main view controller");
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionDidStartRunningNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [UserDefaultsHelper setLastViewedAccount:self.currentAccount];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateAssetGroup];

  self.internetReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraIsReady:) name:AVCaptureSessionDidStartRunningNotification object:nil];
  [self.internetReachable startNotifier];
  self.isInternetReachable = YES;
  
  if ([[UserDefaultsHelper lastViewedAccount] length] > 0) {
    [self.accounts enumerateObjectsUsingBlock:^(ACAccount *acct, NSUInteger idx, BOOL *stop) {
      if ([[acct accountDescription] isEqualToString:[UserDefaultsHelper lastViewedAccount]]) {
        self.indexOfSelectedAccount = idx;
      }
    }];
  }
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
    self.photoViewController.originalImage = self.capturedImage;
    [self.photoViewController.photoView setImage:self.capturedImage];
  } else {
    self.photoViewController.topBar.accountLabel.text = @"No Accounts";
    [self.photoViewController.photoView setImage:[UIImage imageNamed:@"noAccountsImage"]];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (self.accounts.count > 0) {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && !self.capturedImage && !self.shouldShowCameraRoll) {
      self.isCameraReady = NO;
      [self showCameraForSource:UIImagePickerControllerSourceTypeCamera animated:NO];
      
    } else if (self.capturedImage) {
      [self.photoViewController animateButtons];
    }
  }
}

- (void)showCameraForSource:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)animated
{

  if (!self.cameraController) {
    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.delegate = self;
  }
  
  self.cameraController.sourceType = sourceType;
  
  if (sourceType == UIImagePickerControllerSourceTypeCamera)
  {
    if (!self.overlayView) {
      self.overlayView = [[OverlayView alloc] initWithFrame:self.view.bounds];
      self.overlayView.topBar.accountLabel.text = [self currentAccountName];
      self.overlayView.topBar.delegate = self;
      self.overlayView.actionButton.delegate = self;
    }
    self.cameraController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.cameraController.showsCameraControls = NO;
    self.cameraController.cameraViewTransform = [CameraScaleHelper scaleForFullScreen];
    self.cameraController.cameraOverlayView = self.overlayView;
  
  } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    self.cameraController.navigationBarHidden = YES;
  }
  
  [self presentViewController:self.cameraController animated:animated completion:^{
    if (self.photoViewController.didCancelPost) {
      self.photoViewController.didCancelPost = NO;
      [UIView animateWithDuration:0 animations:^{
        self.overlayView.topBar.leftButton.transform = [AnimationHelper scaleShrinkView:self.overlayView.topBar.leftButton];
        self.overlayView.topBar.rightButton.transform = [AnimationHelper scaleShrinkView:self.overlayView.topBar.rightButton];
        
        
      } completion:^(BOOL finished) {
        [self.overlayView.topBar.leftButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:cameraRollState][@"image"] forState:UIControlStateNormal];
        [self.overlayView.topBar.rightButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:frontCameraState][@"image"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{

          self.overlayView.topBar.leftButton.transform = [AnimationHelper scaleExpandView:self.overlayView.topBar.leftButton];
          self.overlayView.topBar.rightButton.transform = [AnimationHelper scaleExpandView:self.overlayView.topBar.rightButton];
        } completion:^(BOOL finished) {
          
        }];
      }];    
    }
  
  }];
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

-(BOOL)isCameraAvailable
{
  return self.isCameraReady;
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

- (void)showPhotoLibrary
{
  self.shouldShowCameraRoll = YES;

  [self dismissViewControllerAnimated:NO completion:^{
    self.rollViewController = [[CameraRollViewController alloc] initWithAssetGroup:self.group] ;
    self.rollViewController.view.frame = self.view.bounds;
    self.rollViewController.topBar.delegate = self;
    self.rollViewController.delegate = self;
    [self presentViewController:self.rollViewController animated:YES completion:nil];
    self.cameraController = nil;
  }];
}

- (void)cancelCameraRoll
{
  [self dismissViewControllerAnimated:YES completion:^{
    if (!self.isPresentingInfoController) {
      [self showCameraForSource:UIImagePickerControllerSourceTypeCamera animated:NO];
    } else {
      self.isPresentingInfoController = NO;
    }
  }];
}

-(UIImage*)originalImage
{
  return self.photoViewController.originalImage;
}

- (void)changeToFilteredImage:(UIImage*)image
{
  self.photoViewController.photoView.image = image;
}

- (void)showInfo
{
  self.infoController = [[InfoViewController alloc] init] ;
  self.infoController.view.frame = self.view.bounds;
  self.infoController.topBar.delegate = self;
  self.isPresentingInfoController = YES;
  [self presentViewController:self.infoController animated:YES completion:nil];
  self.cameraController = nil;
}
#pragma mark - ActionButton Delegate
- (void)twicTaken
{
  [self.cameraController takePicture];
}

-(void)sendTwic
{
  if (self.isInternetReachable) {
    TwitterRequest *twitterRequest = [[TwitterRequest alloc] init];
    twitterRequest.delegate = self;
    [twitterRequest postImage:self.photoViewController.photoView.image withStatus:self.photoViewController.textField.text ?: @""];
    [self.photoViewController cleanupTextViewAndDismissKeyboard];
  } else {
    [ProgressHUD showError:@"Ack! No Internet!"];
    self.photoViewController.isInErrorState = YES;
    [self.photoViewController cleanupTextViewAndDismissKeyboardAfterNoInternetConnection];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [ProgressHUD dismiss];
      self.photoViewController.isInErrorState = NO;
    });
  }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  self.capturedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
  
  UIImageWriteToSavedPhotosAlbum(self.capturedImage, nil, nil, nil);
  
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
  [self shouldResetController];
}
-(void)shouldResetController
{
  self.capturedImage = nil;
  self.isCameraReady = NO;

  [self.photoViewController.topBar.leftButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:cameraRollState][@"image"] forState:UIControlStateNormal];
  [self.photoViewController.topBar.rightButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:frontCameraState][@"image"] forState:UIControlStateNormal];
  [self.photoViewController.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:photoState][@"image"]];
  
  [self showCameraForSource:UIImagePickerControllerSourceTypeCamera animated:NO];
}

#pragma mark - Twitter Delegate
-(void)errorSendingTweetWithString:(NSString*)string
{
  [ProgressHUD showError:[NSString stringWithFormat:@"Error while posting - %@", string]];
  NSLog(@"%@",[NSString stringWithFormat:@"Error while posting - %@", string]);
  double delayInSeconds = 3.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [ProgressHUD dismiss];
  });
}

#pragma mark - Camera Roll Delegate
-(void)didSelectImageFromCameraRoll:(UIImage*)image
{
  self.capturedImage = image;
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - ALAsset Prep
-(void)updateAssetGroup
{
  if (self.assetsLibrary == nil) {
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
  }
  [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    if (nil != group && [group numberOfAssets] > 0) {
      self.group = group;
    }
  } failureBlock:^(NSError *error) {}];
}

#pragma mark - Internet Check
- (void)reachabilityChanged:(NSNotification *)notification
{
  self.isInternetReachable = [[notification object] isReachable];
}

-(BOOL)isInternetAvailable;
{
  return self.isInternetReachable;
}

#pragma mark - Camera Check
- (void)cameraIsReady:(NSNotification *)notification
{
  self.isCameraReady = YES;
}
@end
