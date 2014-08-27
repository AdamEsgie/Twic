 //
//  TwitterRequest.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/11/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "TwitterRequest.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Tweet.h"
#import "AppDelegate.h"

@interface TwitterRequest ()

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

@end

@implementation TwitterRequest

- (id)init
{
  self = [super init];
  if (self) {
    self.accountStore = [[ACAccountStore alloc] init];
  }
  return self;
}

- (void)postTweet:(Tweet *)tweet
{
  [self beginBackgroundUpdateTask];
  
  SLRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    if (responseData) {
      NSInteger statusCode = urlResponse.statusCode;
      if (statusCode >= 200 && statusCode < 300) {
        NSDictionary *postResponseData =
        [NSJSONSerialization JSONObjectWithData:responseData
                                        options:NSJSONReadingMutableContainers
                                          error:NULL];
        tweet.sent = @(YES);
        NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
        [self endBackgroundUpdateTask];
      }
      else {
        [self.delegate errorSendingTweetWithString:[error localizedDescription]];
        [self endBackgroundUpdateTask];
      }
    }
    else {
      [self.delegate errorSendingTweetWithString:[error localizedDescription]];
      [self endBackgroundUpdateTask];
    }
  };
  
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
    NSString *status = tweet.text ? tweet.text : @"";
    NSDictionary *params = @{@"status" : status};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    
  [request addMultipartData:tweet.imageData
                     withName:@"media[]"
                         type:@"image/jpeg"
                     filename:[NSString stringWithFormat:@"%f.jpg", [tweet.date timeIntervalSinceReferenceDate]]];
    [request setAccount:[self.delegate currentAccount]];
    [request performRequestWithHandler:requestHandler];
}


-(void)getAccountsWithCompletionHandler:(void (^)(NSArray*))completionBlock
{
  ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

  [self.accountStore requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
    
    if (granted) {
      completionBlock([self.accountStore accountsWithAccountType:twitterType]);
    } else {
      completionBlock(nil);
    }
  }];
  
}

-(void)getCharacterLengthOfURL
{
  
  NSURL *settingsURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/help/configuration.json"];
  SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                          requestMethod:SLRequestMethodGET
                                                    URL:settingsURL
                                             parameters:nil];
  request.account = [self.delegate currentAccount];
  
  [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    if (responseData) {
      if (urlResponse.statusCode >= 200 &&
          urlResponse.statusCode < 300) {
        
        NSError *jsonError;
        NSDictionary *configutration = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        if (configutration) {
          [self.delegate theCurrentLinkLength:(NSInteger)[configutration[@"characters_reserved_per_media"] longLongValue]];
          [self.delegate maxImageSize:(NSInteger)[configutration[@"photo_size_limit"] longLongValue]];
        }
        else {
          NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
        }
      }
      else {
        NSLog(@"The response status code is %d",
              urlResponse.statusCode);
      }
    }
  }];
}

- (void) beginBackgroundUpdateTask
{
  self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [self endBackgroundUpdateTask];
  }];
}

- (void) endBackgroundUpdateTask
{
  [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
  self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
@end
