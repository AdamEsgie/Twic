//
//  DataManager.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/20/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;

@interface DataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;
+ (void)clearDefaultStore;

- (Tweet *)insertNewTweetWithData:(NSData*)data text:(NSString*)text date:(NSDate*)date sent:(BOOL)sent andAccount:(NSString*)account error:(NSError *__autoreleasing *)error;
- (NSArray *)fetchUnsentTweets:(NSError *__autoreleasing *)error;
- (instancetype)initWithDefaultStore;

@end
