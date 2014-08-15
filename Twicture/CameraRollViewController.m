//
//  CameraRollViewController.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/13/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "CameraRollViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TopBarView.h"
#import "ActionButtonHelper.h"
#import "UserDefaultsHelper.h"
#import "AnimationHelper.h"
#import "NSFileManager+TemporaryFileForAsset.h"

static CGSize const CellSize = {78, 78};
static NSString * const CellReuseIdentifier = @"Cell";

@interface CameraRollViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *group;
@end

@implementation CameraRollViewController

- (instancetype)initWithAssetGroup:(ALAssetsGroup*)group
{
  self.group = group;
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CellSize;
  layout.sectionInset = UIEdgeInsetsZero;
  layout.minimumInteritemSpacing = 2;
  layout.minimumLineSpacing = 2;
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  layout.headerReferenceSize = CGSizeZero;
  layout.footerReferenceSize = CGSizeZero;
  return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  self.collectionView.backgroundColor = [UIColor blackColor];
  self.view.backgroundColor = [UIColor blackColor];
  self.collectionView.alwaysBounceVertical = YES;
  self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
  
  [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
  
  self.topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, buttonSize)];
  [self.topBar.leftButton setImage:[ActionButtonHelper leftButtonDictionaryForState:cancelCameraRollState][@"image"] forState:UIControlStateNormal];
  [self.topBar.leftButton addTarget:self.topBar action:NSSelectorFromString([ActionButtonHelper leftButtonDictionaryForState:cancelCameraRollState][@"selector"]) forControlEvents:UIControlEventTouchUpInside];
  self.topBar.accountLabel.text = @"Photos";
  [self.topBar.frontCameraButton removeFromSuperview];
  self.topBar.frontCameraButton = nil;
  [self.view addSubview:self.topBar];
}
- (void)viewWillAppear:(BOOL)animated
{
  
  [super viewWillAppear:animated];
  
  if (!self.assets) {
    self.assets = [[NSMutableArray alloc] init];
  } else {
    [self.assets removeAllObjects];
  }
  
  ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
    
    if (result) {
      [self.assets addObject:result];
    }
  };
  
  ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
  [self.group setAssetsFilter:onlyPhotosFilter];
  [self.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetsEnumerationBlock];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
  
  [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
  imageView.image = [self imageForItemAtIndex:indexPath.item];
  
  [cell.contentView addSubview:imageView];
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSURL *tempUrl = [[NSFileManager defaultManager] createTemporaryFileForAsset:self.assets[indexPath.row]];
  NSData *data = [NSData dataWithContentsOfURL:tempUrl];
  UIImage *image = [UIImage imageWithData:data];
  
  [self.delegate didSelectImageFromCameraRoll:image];
}

- (UIImage *)imageForItemAtIndex:(NSInteger)index
{
  ALAsset *item = self.assets[index];
  
  return [UIImage imageWithCGImage:item.thumbnail];
}

@end
