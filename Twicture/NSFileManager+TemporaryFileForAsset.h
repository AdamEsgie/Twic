
#import <Foundation/Foundation.h>


@class ALAsset, ALAssetRepresentation;


@interface NSFileManager (TemporaryFileForAsset)

- (NSURL *)createTemporaryFileForAsset:(ALAsset *)asset;
- (NSURL *)createTemporaryFileForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;
- (BOOL)removeTemporaryFileForAsset:(ALAsset *)asset error:(NSError **)error;
- (BOOL)removeTemporaryFileForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation error:(NSError **)error;

@end
