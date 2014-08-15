//
//  NSString+Md5Digest.m
//  AvatarForEmail
//
//  Created by Karol Kozub on 02.07.2012.
//  Copyright (c) 2012 Macoscope. All rights reserved.
//

#import "NSString+Md5Digest.h"

@implementation NSString (Md5Digest)
- (NSString *)md5DigestUsingEncoding:(NSStringEncoding)encoding
{
  NSMutableString *digest = [NSMutableString string];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  const char *cString = [self cStringUsingEncoding:encoding];
  
  CC_MD5(cString, strlen(cString), result);
  
  for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [digest appendFormat:@"%02x", result[i]];
  }
  
  return digest;
}

- (NSString *)md5Digest
{
  return [self md5DigestUsingEncoding:NSUTF8StringEncoding];
}
@end
