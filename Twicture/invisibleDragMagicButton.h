//
//  invisibleDragMagicButton.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvisibleButtonDelegate <NSObject>

-(void)centerCommentButtonAnimated:(BOOL)animated;

@end

@interface InvisibleDragMagicButton : UIButton

@property (nonatomic,weak)id<InvisibleButtonDelegate> delegate;

@end
