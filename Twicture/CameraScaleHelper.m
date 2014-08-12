
#import "CameraScaleHelper.h"
#import "ActionButton.h"
#import "UserDefaultsHelper.h"

@implementation CameraScaleHelper

+(CGAffineTransform)scaleForFullScreen
{
  CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0,buttonSize);
  return CGAffineTransformScale(translate, LivePreviewNewHeight/LivePreviewDefaultHeight, LivePreviewNewHeight/LivePreviewDefaultHeight);
}

@end
