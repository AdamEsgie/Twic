//
//  TopBarView.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "TopBarView.h"
#import "UserDefaultsHelper.h"

@implementation TopBarView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
      self.backgroundColor = YellowButtonColor;
      [self addButtons];
    }
    return self;
}

- (void)addButtons
{
  self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - self.height, 0, buttonSize, buttonSize)];
  [self.rightButton addTarget:self action:@selector(frontCameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self.rightButton setImage:[UIImage imageNamed:@"frontCameraIcon"] forState:UIControlStateNormal];
  [self addSubview:self.rightButton];
  
  self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
  [self addSubview:self.leftButton];
  
  self.accountButton = [[UIButton alloc] initWithFrame:CGRectMake(self.leftButton.right, 0, self.width - self.leftButton.width - self.rightButton.width, self.height)];
  [self.accountButton addTarget:self action:@selector(accountButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.accountButton];
  
  self.accountLabel = [[UILabel alloc] initWithFrame:self.accountButton.frame];
  self.accountLabel.font = DefaultTitleFont;
  self.accountLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:self.accountLabel];
}

-(IBAction)rollTapped:(id)sender
{
  [self.delegate showPhotoLibrary];
}

-(IBAction)infoButtonTapped:(id)sender
{
  
}

-(IBAction)cancelCameraRollTapped:(id)sender
{
  [self.delegate cancelCameraRoll];
}

-(IBAction)frontCameraButtonTapped:(id)sender
{
  [self.delegate changeCamera];
}

-(IBAction)accountButtonTapped:(id)sender
{
  NSString *nextAccountName = [self.delegate nextAccountName];
  self.accountLabel.text = nextAccountName;
}

-(IBAction)filterButtonTapped:(id)sender
{
  CIImage *beginImage = [[CIImage alloc] initWithCGImage:[self.delegate currentImage].CGImage options:nil];
  
  CIContext *context = [CIContext contextWithOptions:nil];
  
  CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", @0.8, nil];
  
  CIImage *outputImage = [filter outputImage];
  CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
  
  UIImage *newImage = [UIImage imageWithCGImage:cgimg];
  [self.delegate changeToFilteredImage:[self rotate:newImage andOrientation:newImage.imageOrientation]];
  
  CGImageRelease(cgimg);
  
}

-(UIImage*) rotate:(UIImage*) src andOrientation:(UIImageOrientation)orientation
{
  UIGraphicsBeginImageContext(src.size);
  
  CGContextRef context=(UIGraphicsGetCurrentContext());
  
  if (orientation == UIImageOrientationRight) {
    CGContextRotateCTM (context, 90/180*M_PI) ;
  } else if (orientation == UIImageOrientationLeft) {
    CGContextRotateCTM (context, -90/180*M_PI);
  } else if (orientation == UIImageOrientationDown) {

  } else if (orientation == UIImageOrientationUp) {
    CGContextRotateCTM (context, 90/180*M_PI);
  }
  
  [src drawAtPoint:CGPointMake(0, 0)];
  UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
  
}

@end
