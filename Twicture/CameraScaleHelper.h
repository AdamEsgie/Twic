
#import <Foundation/Foundation.h>

static const CGFloat LivePreviewNewHeight = 454;
static const CGFloat LivePreviewDefaultHeight = 426;

@interface CameraScaleHelper : NSObject

+(CGAffineTransform)scaleForFullScreen;

@end
