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

@interface TwitterRequest ()

@property (nonatomic, strong) ACAccountStore *accountStore;

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

- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
  ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  SLRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    if (responseData) {
      NSInteger statusCode = urlResponse.statusCode;
      if (statusCode >= 200 && statusCode < 300) {
        NSDictionary *postResponseData =
        [NSJSONSerialization JSONObjectWithData:responseData
                                        options:NSJSONReadingMutableContainers
                                          error:NULL];
        NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
      }
      else {
        NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
              [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
        [self.delegate errorSendingTweet];
      }
    }
    else {
      NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
      [self.delegate errorSendingTweet];
    }
  };
  
  ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
  ^(BOOL granted, NSError *error) {
    if (granted) {

      NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
      NSDictionary *params = @{@"status" : status};
      SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:SLRequestMethodPOST
                                                        URL:url
                                                 parameters:params];
      NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
      [request addMultipartData:imageData
                       withName:@"media[]"
                           type:@"image/jpeg"
                       filename:@"image.jpg"];
      [request setAccount:[self.delegate currentAccount]];
      [request performRequestWithHandler:requestHandler];
    }
    else {
      NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
            [error localizedDescription]);
      [self.delegate errorSendingTweet];
    }
  };
  
  [self.accountStore requestAccessToAccountsWithType:twitterType
                                             options:NULL
                                          completion:accountStoreHandler];
}

-(NSArray*)getAccounts
{
  ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  return [self.accountStore accountsWithAccountType:twitterType];
}
@end
