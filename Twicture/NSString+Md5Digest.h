//
//  NSString+Md5Digest.h
//  AvatarForEmail
//
//  Created by Karol Kozub on 02.07.2012.
//  Copyright (c) 2012 Macoscope. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@interface NSString (Md5Digest)
- (NSString *)md5DigestUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)md5Digest;
@end
