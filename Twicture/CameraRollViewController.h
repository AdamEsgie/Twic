//
//  CameraRollViewController.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/13/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup, TopBarView;

@protocol CameraRollDelegate <NSObject>

-(void)didSelectImageFromCameraRoll:(UIImage*)image;

@end

@interface CameraRollViewController : UICollectionViewController

@property (nonatomic, strong) TopBarView *topBar;
@property (nonatomic, weak) id <CameraRollDelegate> delegate;

- (instancetype)initWithAssetGroup:(ALAssetsGroup*)group;

@end
