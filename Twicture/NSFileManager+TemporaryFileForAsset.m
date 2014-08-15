//
//  NSFileManager+TemporaryFileForAsset.m
//  BirdseyeMail
//
//  Created by Karol Kozub on 18/06/14.
//  Copyright (c) 2014 Birdseye. All rights reserved.
//

#import "NSFileManager+TemporaryFileForAsset.h"
#import "NSString+Md5Digest.h"
#import <AssetsLibrary/AssetsLibrary.h>


static const NSUInteger BufferSize = 1024 * 1024;


@implementation NSFileManager (TemporaryFileForAsset)

- (NSURL *)createTemporaryFileForAsset:(ALAsset *)asset
{
  return [self createTemporaryFileForAssetRepresentation:asset.defaultRepresentation];
}

- (NSURL *)createTemporaryFileForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation
{
  NSURL *temporaryFileUrl = [self temporaryFileUrlForAssetRepresentation:assetRepresentation];

  if (![self fileExistsAtPath:temporaryFileUrl.path]) {
    [self createFileAtPath:temporaryFileUrl.path contents:nil attributes:nil];
    
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:temporaryFileUrl error:nil];
    uint8_t *buffer = calloc(BufferSize, sizeof(uint8_t));
    
    @try {
      for (NSInteger offset = 0, bytesRead = NSIntegerMax; bytesRead > 0; offset += bytesRead) {
        bytesRead = [assetRepresentation getBytes:buffer fromOffset:offset length:BufferSize error:nil];
        [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
      }
    } @catch (NSException *_) {
      temporaryFileUrl = nil;
      
    } @finally {
      free(buffer);
    }
  }
  
  return temporaryFileUrl;
}

- (BOOL)removeTemporaryFileForAsset:(ALAsset *)asset error:(NSError **)error
{
  return [self removeTemporaryFileForAssetRepresentation:asset.defaultRepresentation error:error];
}

- (BOOL)removeTemporaryFileForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation error:(NSError **)error
{
  return [self removeItemAtURL:[self temporaryFileUrlForAssetRepresentation:assetRepresentation] error:error];
}

- (NSURL *)temporaryFileUrlForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation
{
  NSURL *temporaryDirectoryUrl = [self temporaryAssetFileDirectoryUrl];
  NSString *uniqueFilename = [NSString stringWithFormat:@"%@_%@", assetRepresentation.url.absoluteString.md5Digest, assetRepresentation.filename];
  
  return [temporaryDirectoryUrl URLByAppendingPathComponent:uniqueFilename];
}

- (NSURL *)temporaryAssetFileDirectoryUrl
{
  return [self URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
}

@end
