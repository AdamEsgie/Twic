//
//  ActionButton.h
//  Twicture
//
//  Created by Adam Salvitti-Gucwa on 8/8/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionButtonDelegate <NSObject>

-(void)twicTaken;
-(void)sendTwic;
-(BOOL)isInternetAvailable;
-(BOOL)isCameraAvailable;

@end

@interface ActionButton : UIButton

@property (nonatomic, weak) id<ActionButtonDelegate> delegate;
@property (nonatomic) BOOL shouldAnimateOval;
@property (nonatomic, strong) UIImageView *actionView;

-(IBAction)takePhotoTapped:(id)sender;
-(IBAction)commentTapped:(id)sender;
-(IBAction)sendTapped:(id)sender;
-(IBAction)cancelTapped:(id)sender;
-(void)clearTargetsAndActions;
-(void)addTargetAtIndex:(NSInteger)index;
@end
