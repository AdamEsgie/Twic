//
//  PhotoViewController.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "PhotoViewController.h"
#import "ActionButton.h"
#import "ActionButtonHelper.h"
#import "UserDefaultsHelper.h"
#import "TopBarView.h"
#import "BottomBarView.h"
#import "ColorHelper.h"
#import "InvisibleDragMagicButton.h"
#import "AnimationHelper.h"

@interface PhotoViewController () <InvisibleButtonDelegate>

@property (nonatomic, strong) ActionButton *actionButton;
@property (nonatomic, strong) InvisibleDragMagicButton *invisibleDragMagicButton;
@property (nonatomic, strong) UIImage *photoTakenImage;
@property (nonatomic, strong) UITextField *textField;
@property BOOL animatingDrag;
@property BOOL dragging;
@end

@implementation PhotoViewController

- (id)initWithPhoto:(UIImage*)image
{
    self = [super init];
    if (self) {
      self.photoTakenImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void)setup
{
  self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, buttonSize, self.view.width, self.view.height-buttonSize*2)];
  [self.photoView setImage:self.photoTakenImage];
  [self.view addSubview:self.photoView];
  
  self.topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, buttonSize)];
  [self.view addSubview:self.topBar];
  
  self.bottomBar = [[BottomBarView alloc] initWithFrame:CGRectMake(0, self.view.height-buttonSize, self.view.width, buttonSize)];
  [self.view addSubview:self.bottomBar];
  
  self.actionButton = [[ActionButton alloc] initWithFrame:CGRectMake(self.view.width/2 - buttonSize/2, self.view.height - buttonSize, buttonSize, buttonSize)];
  [self.view addSubview:self.actionButton];
  
  self.invisibleDragMagicButton = [InvisibleDragMagicButton new];
  self.invisibleDragMagicButton.delegate = self;
  [self.invisibleDragMagicButton addTarget:self action:@selector(draggedOut:withEvent:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
  [self.invisibleDragMagicButton addTarget:self action:@selector(commentInitiated:) forControlEvents:UIControlEventTouchUpInside];
  self.invisibleDragMagicButton.frame = CGRectMake(self.view.width/2-buttonSize/2, self.view.height-buttonSize, buttonSize, buttonSize);
  [self.view addSubview:self.invisibleDragMagicButton];
}

-(void)animateCommentButton
{
  [UIView animateWithDuration:0.15 animations:^{
    self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
    
  } completion:^(BOOL finished) {
    [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:commentState][@"image"]];
  
    [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
    } completion:^(BOOL finished) {
      [self.actionButton clearTargetsAndActions];
      [self.actionButton addTargetAtIndex:commentState];
    }];
  }];
}

#pragma mark - InvisibleDragMagicButton Delegate
-(void)centerCommentButtonAnimated:(BOOL)animated
{
  CGFloat time = animated ? 0.3 : 0;
  
  if (!self.animatingDrag && self.dragging) {
    [UIView animateWithDuration:time delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.invisibleDragMagicButton.center = CGPointMake(self.view.width/2, self.invisibleDragMagicButton.center.y);
      self.actionButton.center = CGPointMake(self.view.width/2, self.actionButton.center.y);
    } completion:^(BOOL finished) {
      self.topBar.backgroundColor = [ColorHelper colorForOffset:self.invisibleDragMagicButton.center.x];
      self.bottomBar.backgroundColor = [ColorHelper colorForOffset:self.invisibleDragMagicButton.center.x];
      self.dragging = NO;
    }];
  }
}

- (IBAction)draggedOut:(id)sender withEvent:(UIEvent *)event
{
  self.dragging = YES;
  
  CGPoint dragPoint = [[[event allTouches] anyObject] locationInView:self.view];
  
  self.topBar.backgroundColor = [ColorHelper colorForOffset:dragPoint.x];
  self.bottomBar.backgroundColor = [ColorHelper colorForOffset:dragPoint.x];
  
  
  if (!self.animatingDrag) {
    if (dragPoint.x <= self.view.width/3) {
      
      [UIView animateWithDuration:0.15 animations:^{
        self.animatingDrag = YES;
        self.actionButton.center = CGPointMake(buttonSize/2, self.actionButton.center.y);
        self.invisibleDragMagicButton.center = CGPointMake(buttonSize/2, self.invisibleDragMagicButton.center.y);
        
      }completion:^(BOOL finished) {
        
        self.topBar.backgroundColor = [ColorHelper colorForOffset:self.actionButton.center.x];
        self.bottomBar.backgroundColor = [ColorHelper colorForOffset:self.actionButton.center.x];
        
        [UIView animateWithDuration:0.15 animations:^{
          self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
          
        } completion:^(BOOL finished) {
          
          [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:cancelState][@"image"]];
          
          [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
          } completion:^(BOOL finished) {
            
            [self.delegate shouldCancelTwic];
            self.animatingDrag = NO;
          }];
        }];
      }];
      
    } else if (dragPoint.x >= (self.view.width - self.view.width/3)) {
      
      [UIView animateWithDuration:0.15 animations:^{
        self.animatingDrag = YES;
        self.actionButton.center = CGPointMake(self.view.width-self.actionButton.width/2, self.actionButton.center.y);
        self.invisibleDragMagicButton.center = CGPointMake(self.view.width-self.actionButton.width/2, self.invisibleDragMagicButton.center.y);;
        
      } completion:^(BOOL finished) {
        
        self.topBar.backgroundColor = [ColorHelper colorForOffset:self.actionButton.center.x];
        self.bottomBar.backgroundColor = [ColorHelper colorForOffset:self.actionButton.center.x];
        
        [UIView animateWithDuration:0.15 animations:^{
          self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
          
        } completion:^(BOOL finished) {
          
          [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:sendState][@"image"]];
          
          [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
          } completion:^(BOOL finished) {
            
            [self.delegate shouldStartSendingTwic];
            self.animatingDrag = NO;
          }];
        }];
      }];
      
    } else {

      self.actionButton.center = CGPointMake(dragPoint.x, self.actionButton.center.y);
      self.invisibleDragMagicButton.center = CGPointMake(self.actionButton.center.x, self.invisibleDragMagicButton.center.y);
    }
  }
  
}


-(IBAction)commentInitiated:(id)sender
{
  if (!self.dragging) {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(buttonSize, self.bottomBar.top, self.view.width - (buttonSize*2), self.bottomBar.height)];
    self.textField.font = DefaultTextFieldFont;
    self.textField.tintColor = [UIColor blackColor];
    [self.view addSubview:self.textField];
    [self.textField becomeFirstResponder];
  }
}
#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
  CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
  
  [UIView animateWithDuration:duration animations:^{
    [UIView setAnimationCurve:curve];
    self.textField.frame = CGRectMake(self.textField.origin.x, self.view.height - keyboardRect.size.height - self.textField.height, self.textField.width, self.textField.height);
    self.bottomBar.frame = CGRectMake(self.bottomBar.origin.x, self.view.height - keyboardRect.size.height - self.bottomBar.height, self.bottomBar.width, self.bottomBar.height);
  } completion:^(BOOL finished) {
    
  }];

}

-(void)keyboardDidHide:(NSNotification *)notification
{
  self.textField.frame = CGRectMake(self.textField.origin.x, self.view.height - self.textField.height, self.textField.width, self.textField.height);
  self.bottomBar.frame = CGRectMake(self.bottomBar.origin.x, self.view.height - self.bottomBar.height, self.bottomBar.width, self.bottomBar.height);
}
@end
