//
//  TopBarView.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "TopBarView.h"
#import "UserDefaultsHelper.h"
#import <CoreImage/CoreImage.h>

@implementation TopBarView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
      self.backgroundColor = YellowButtonColor;
      [self addButtons];
      self.filter = originalPhoto;
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
  [self.delegate showInfo];
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
  CIImage *beginImage = [[CIImage alloc] initWithCGImage:[self.delegate originalImage].CGImage options:nil];
  
  CIContext *context = [CIContext contextWithOptions:nil];
  CIFilter *filter;
  
//  if (self.filter == originalPhoto) {
    filter = [CIFilter filterWithName:@"CIPhotoEffectMono" keysAndValues:kCIInputImageKey, beginImage, nil];
//    self.filter = blackAndWhitePhoto;
//  } else if (self.filter == blackAndWhitePhoto) {
//    filter = [CIFilter filterWithName:@"CIPhotoEffectChrome" keysAndValues:kCIInputImageKey, beginImage, nil];
//    self.filter = chromePhoto;
//  } else {
//    self.filter = originalPhoto;
//    return [self.delegate changeToFilteredImage:[self.delegate originalImage]];
//  }
  
//  filter = [CIFilter filterWithName:@"CIAffineTile" keysAndValues:
//                              kCIInputImageKey, beginImage,
//                              nil];
  
  CIImage *outputImage = [filter outputImage];
  CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
  
  UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:UIImageOrientationRight];
  [self.delegate changeToFilteredImage:newImage];
  
  CGImageRelease(cgimg);
}



@end
