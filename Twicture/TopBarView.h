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

@end

@interface TopBarView : UIView

@property (nonatomic, weak) id <TopBarDelegate> delegate;

@property (nonatomic, strong) UIButton *frontCameraButton;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *accountButton;
@property (nonatomic, strong) UILabel *accountLabel;

- (id)initWithFrame:(CGRect)frame andDelegate:(id<TopBarDelegate>)delegate;
@end
