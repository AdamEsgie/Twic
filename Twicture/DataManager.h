//
//  DataManager.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/20/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (instancetype)initWithDefaultStore;
- (instancetype)initWithStoreUrl:(NSURL *)storeUrl;
+ (void)clearDefaultStore;

@end
