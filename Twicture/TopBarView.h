//
//  TopBarView.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/10/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopBarDelegate <NSObject>

- (NSString*)nextAccountName;
- (void)changeCamera;
- (void)showPhotoLibrary;
- (void)cancelCameraRoll;
- (void)changeToFilteredImage:(UIImage*)image;
- (UIImage*)originalImage;
- (void)showInfo;
@end

@interface TopBarView : UIView

@property (nonatomic, weak) id <TopBarDelegate> delegate;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *accountButton;
@property (nonatomic, strong) UILabel *accountLabel;
@property NSInteger filter;

- (id)initWithFrame:(CGRect)frame andDelegate:(id<TopBarDelegate>)delegate;
-(IBAction)rollTapped:(id)sender;
-(IBAction)infoButtonTapped:(id)sender;
-(IBAction)cancelCameraRollTapped:(id)sender;
-(IBAction)frontCameraButtonTapped:(id)sender;
-(IBAction)accountButtonTapped:(id)sender;
-(IBAction)filterButtonTapped:(id)sender;
@end
