//
//  invisibleDragMagicButton.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "InvisibleDragMagicButton.h"

@implementation InvisibleDragMagicButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.frame = frame;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  [self.nextResponder touchesEnded:touches withEvent:event];
  
  [self.delegate centerCommentButtonAnimated:YES];
}


@end
