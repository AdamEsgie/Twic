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
#import "ProgressHUD.h"

@interface PhotoViewController () <InvisibleButtonDelegate, ActionButtonDelegate, UITextFieldDelegate>

@property (nonatomic, strong) InvisibleDragMagicButton *invisibleDragMagicButton;
@property (nonatomic, strong) UIView *tapView;
@property BOOL canceledTextField;
@property BOOL animatingDrag;
@property BOOL dragging;

@end

@implementation PhotoViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
      self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  if ([self.delegate hasAccounts]) {
    self.topBar.accountLabel.text = [self.delegate currentAccountName];
    
  } else {
    [self disableButtonsIfNoAccounts];
    self.topBar.accountLabel.text = @"No Accounts";
    [self.photoView setImage:[UIImage imageNamed:@"noAccountsImage"]];
  }
}

-(void)viewDidAppear:(BOOL)animated
{
  [self setup];
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
  if (!self.photoView) {
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, buttonSize, self.view.width, self.view.height-buttonSize*2)];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.photoView];
  }
  
  if(!self.topBar) {
    self.topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, buttonSize)];
    [self.topBar.leftButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:cameraRollState][@"image"] forState:UIControlStateNormal];
    [self.topBar.leftButton addTarget:self.topBar action:NSSelectorFromString([ActionButtonHelper topBarButtonDictionaryForState:cameraRollState][@"selector"]) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topBar];
  }
  
  if (!self.bottomBar) {
    self.bottomBar = [[BottomBarView alloc] initWithFrame:CGRectMake(0, self.view.height-buttonSize, self.view.width, buttonSize)];
    [self.view addSubview:self.bottomBar];
  }
  
  if (!self.actionButton) {
    self.actionButton = [[ActionButton alloc] initWithFrame:CGRectMake(self.view.width/2 - buttonSize/2, self.view.height - buttonSize, buttonSize, buttonSize)];
    [self.view addSubview:self.actionButton];
  }
  
  if (!self.invisibleDragMagicButton) {
    self.invisibleDragMagicButton = [InvisibleDragMagicButton new];
    self.invisibleDragMagicButton.delegate = self;
    [self.invisibleDragMagicButton addTarget:self action:@selector(draggedOut:withEvent:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    [self.invisibleDragMagicButton addTarget:self action:@selector(commentInitiated:) forControlEvents:UIControlEventTouchUpInside];
    self.invisibleDragMagicButton.frame = CGRectMake(self.view.width/2-buttonSize/2, self.view.height-buttonSize, buttonSize, buttonSize);
    [self.view addSubview:self.invisibleDragMagicButton];
  }

}

-(void)animateButtons
{
  [UIView animateWithDuration:0.15 animations:^{
    self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
    self.topBar.leftButton.transform = [AnimationHelper scaleShrinkView:self.topBar.leftButton];
    self.topBar.rightButton.transform = [AnimationHelper scaleShrinkView:self.topBar.rightButton];
    
    
  } completion:^(BOOL finished) {
    [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:commentState][@"image"]];
    [self.topBar.leftButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:infoState][@"image"] forState:UIControlStateNormal];
    [self.topBar.leftButton removeTarget:self.topBar action:NULL forControlEvents:UIControlEventAllEvents];
    [self.topBar.leftButton addTarget:self.topBar action:NSSelectorFromString([ActionButtonHelper topBarButtonDictionaryForState:infoState][@"selector"]) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar.rightButton setImage:[ActionButtonHelper topBarButtonDictionaryForState:filterState][@"image"] forState:UIControlStateNormal];
    [self.topBar.rightButton removeTarget:self.topBar action:NULL forControlEvents:UIControlEventAllEvents];
    [self.topBar.rightButton addTarget:self.topBar action:NSSelectorFromString([ActionButtonHelper topBarButtonDictionaryForState:filterState][@"selector"]) forControlEvents:UIControlEventTouchUpInside];
  
    [UIView animateWithDuration:0.15 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
      self.topBar.leftButton.transform = [AnimationHelper scaleExpandView:self.topBar.leftButton];
      self.topBar.rightButton.transform = [AnimationHelper scaleExpandView:self.topBar.rightButton];
    } completion:^(BOOL finished) {
      
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
  
  if (!self.animatingDrag && [self.delegate isInternetAvailable]) {
    self.topBar.backgroundColor = [ColorHelper colorForOffset:dragPoint.x];
    self.bottomBar.backgroundColor = [ColorHelper colorForOffset:dragPoint.x];
  }
  
  
  if (!self.animatingDrag) {
    
    if (dragPoint.x <= buttonSize) {
      
        [UIView animateWithDuration:0.15 animations:^{
          self.animatingDrag = YES;
          self.actionButton.center = CGPointMake(buttonSize/2, self.actionButton.center.y);
          self.invisibleDragMagicButton.center = CGPointMake(buttonSize/2, self.invisibleDragMagicButton.center.y);
          
        }completion:^(BOOL finished) {
          
          self.topBar.backgroundColor = RedButtonColor;
          self.bottomBar.backgroundColor = RedButtonColor;
          
          [UIView animateWithDuration:0.15 animations:^{
            self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
            
          } completion:^(BOOL finished) {
            
            [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:cancelState][@"image"]];
            
            [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
              self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
            } completion:^(BOOL finished) {
              
              [self makeBarsYellow];
              
              [UIView animateWithDuration:0.10 animations:^{
                self.invisibleDragMagicButton.center = CGPointMake(self.view.width/2, self.invisibleDragMagicButton.center.y);
                self.actionButton.center = CGPointMake(self.view.width/2, self.actionButton.center.y);
              } completion:^(BOOL finished) {
                self.animatingDrag = NO;
                self.didCancelPost = YES;
                self.originalImage = nil;
                self.photoView.image = nil;
                [self.delegate shouldResetController];
              }];
            }];
          }];
        }];
    } else if (dragPoint.x >= (self.view.width - buttonSize)) {
      
      if (![self.delegate isInternetAvailable]) {
        [ProgressHUD showError:@"No Internet!"];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          [ProgressHUD dismiss];
        });
      } else {
        [UIView animateWithDuration:0.15 animations:^{
          self.animatingDrag = YES;
          self.actionButton.center = CGPointMake(self.view.width-self.actionButton.width/2, self.actionButton.center.y);
          self.invisibleDragMagicButton.center = CGPointMake(self.view.width-self.actionButton.width/2, self.invisibleDragMagicButton.center.y);;
          
        } completion:^(BOOL finished) {
          
          self.topBar.backgroundColor = GreenButtonColor;
          self.bottomBar.backgroundColor = GreenButtonColor;
          
          [UIView animateWithDuration:0.15 animations:^{
            self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
            
          } completion:^(BOOL finished) {
            
            [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:sendState][@"image"]];
            
            [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
              self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
            
            } completion:^(BOOL finished) {
              [self makeBarsYellow];
              
              [UIView animateWithDuration:0.10 animations:^{
                self.invisibleDragMagicButton.center = CGPointMake(self.view.width/2, self.invisibleDragMagicButton.center.y);
                self.actionButton.center = CGPointMake(self.view.width/2, self.actionButton.center.y);
              } completion:^(BOOL finished) {
                [self.delegate shouldStartSendingTwic];
                self.animatingDrag = NO;
                self.originalImage = nil;
                self.photoView.image = nil;
              }];
            }];
          }];
        }];
      }
      
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
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    [self.textField becomeFirstResponder];
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSUInteger newLength = [textField.text length] + [string length] - range.length;
  return (newLength > (140 - self.linkLength)) ? NO : YES;
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
  CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
  
  
  [self.actionButton clearTargetsAndActions];
  [self.actionButton addTargetAtIndex:sendState];
  
  [UIView animateWithDuration:duration animations:^{
    
    [UIView setAnimationCurve:curve];
    self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
    self.textField.frame = CGRectMake(self.textField.origin.x, self.view.height - keyboardRect.size.height - self.textField.height, self.textField.width, self.textField.height);
    self.bottomBar.frame = CGRectMake(self.bottomBar.origin.x, self.view.height - keyboardRect.size.height - self.bottomBar.height, self.bottomBar.width, self.bottomBar.height);
    self.actionButton.frame = CGRectMake(self.actionButton.origin.x, self.view.height - keyboardRect.size.height - self.actionButton.height, self.actionButton.width, self.actionButton.height);
  } completion:^(BOOL finished) {
    
    [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:sendState][@"image"]];
    
    [UIView animateWithDuration:0.10 animations:^{
      self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
      self.actionButton.center = CGPointMake(self.view.width-self.actionButton.width/2, self.actionButton.center.y);
    } completion:^(BOOL finished) {}];
  }];

  [self addTapRecognizerToDismiss];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
  NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
  
  [self.actionButton clearTargetsAndActions];
  [self.actionButton addTargetAtIndex:photoState];
  
  [UIView animateWithDuration:duration animations:^{
    
    [UIView setAnimationCurve:curve];
    if (!self.isInErrorState) {
    self.actionButton.actionView.transform = [AnimationHelper scaleShrinkView:self.actionButton.actionView];
    }
    self.textField.frame = CGRectMake(self.textField.origin.x, self.view.height - self.textField.height, self.textField.width, self.textField.height);
    self.bottomBar.frame = CGRectMake(self.bottomBar.origin.x, self.view.height - self.bottomBar.height, self.bottomBar.width, self.bottomBar.height);
    self.actionButton.frame = CGRectMake(self.actionButton.origin.x, self.view.height - self.actionButton.height, self.actionButton.width, self.actionButton.height);
  } completion:^(BOOL finished) {
    
    if (self.canceledTextField) {
      [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:commentState][@"image"]];
    } else if (!self.isInErrorState) {
      [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:photoState][@"image"]];
    }

    
    [UIView animateWithDuration:0.10 animations:^{
      if (!self.isInErrorState) {
        self.actionButton.actionView.transform = [AnimationHelper scaleExpandView:self.actionButton.actionView];
      }
      self.actionButton.center = CGPointMake(self.view.width/2, self.actionButton.center.y);
    } completion:^(BOOL finished) {
      
      if (!self.canceledTextField) {
        [self makeBarsYellow];
        [self.delegate shouldResetController];
        [self.actionButton.actionView setImage:[ActionButtonHelper actionDictionaryForState:commentState][@"image"]];
      }
      self.canceledTextField = NO;
      
    }];
  }];
}

-(void)cleanupTextViewAndDismissKeyboardAfterNoInternetConnection
{
  [self cleanupTextView];
  
  self.topBar.backgroundColor = YellowButtonColor;
  self.bottomBar.backgroundColor = YellowButtonColor;
}

-(void)cleanupTextViewAndDismissKeyboard
{
  [self cleanupTextView];
  
  self.topBar.backgroundColor = GreenButtonColor;
  self.bottomBar.backgroundColor = GreenButtonColor;
}

-(void)cleanupTextView
{
  [self.textField resignFirstResponder];
  [self.textField removeFromSuperview];
  self.textField = nil;
  
  [self.tapView removeFromSuperview];
  self.tapView = NO;
}

-(void)cleanupOnTextViewCancel
{
  self.canceledTextField = YES;
  [self cleanupTextView];
}

-(void)disableButtonsIfNoAccounts
{
  self.topBar.userInteractionEnabled = NO;
  self.actionButton.userInteractionEnabled = NO;
  self.invisibleDragMagicButton.userInteractionEnabled = NO;
  self.bottomBar.userInteractionEnabled = NO;
}

-(void)addTapRecognizerToDismiss
{
  self.tapView = [[UIView alloc] init];
  self.tapView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), self.view.height - self.textField.top);
  [self.view addSubview:self.tapView];
  
  UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanupOnTextViewCancel)];
  [self.tapView setGestureRecognizers:[NSArray arrayWithObject:tap]];
  
}

-(void)makeBarsYellow
{
  self.topBar.backgroundColor = YellowButtonColor;
  self.bottomBar.backgroundColor = YellowButtonColor;
}
@end
