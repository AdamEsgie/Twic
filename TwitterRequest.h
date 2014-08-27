//
//  TwitterRequest.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACAccount, Tweet;

@protocol TwitterDelegate <NSObject>
@optional
-(void)errorSendingTweetWithString:(NSString*)string;
-(ACAccount*)currentAccount;
-(void)successSendingTweet;
-(void)theCurrentLinkLength:(NSInteger)length;
-(void)maxImageSize:(NSInteger)maxImageSize;

@end

@interface TwitterRequest : NSObject

@property (nonatomic, strong, readonly) NSArray *accounts;
@property (nonatomic, weak) id <TwitterDelegate> delegate;

- (void)postImage:(UIImage *)image withStatus:(NSString *)status;
- (void)postTweet:(Tweet *)tweet;
-(void)getAccountsWithCompletionHandler:(void (^)(NSArray*))completionBlock;
- (void)getCharacterLengthOfURL;

@end
