//
//  DataManager.m
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/20/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>
#import "Tweet.h"

@implementation DataManager

- (instancetype)initWithDefaultStore
{
  return [self initWithStoreUrl:[[self class] defaultStoreUrl]];
}

- (instancetype)initWithStoreUrl:(NSURL *)storeUrl
{
  self = [super init];
  
  if (self) {
    
    self.persistentStoreCoordinator = [self createPersistentStoreCoordinatorWithStoreUrl:storeUrl managedObjectModel:nil];
    self.mainManagedObjectContext = [self createMainManagedObjectContext];
  }
  
  return self;
}

- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorWithStoreUrl:(NSURL *)storeUrl managedObjectModel:(NSManagedObjectModel *)managedObjectModel
{
  NSParameterAssert(storeUrl);
  
  NSError *error;
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
  
  if (managedObjectModel == nil) {
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self createManagedObjectModel]];
  } else {
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
  }
  
  [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
  
  if (nil != error) {
    error = nil;
    
    [[NSFileManager defaultManager] removeItemAtURL:storeUrl error:&error];
    
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
  }
  
  if (nil != error) {
    NSLog(@"Error when adding persistent store: %@", error);
  }
  
  return persistentStoreCoordinator;
}

- (NSManagedObjectModel *)createManagedObjectModel
{
  return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Twic" withExtension:@"momd"]];
}

+ (NSURL *)defaultStoreUrl
{
  NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
  return [documentDirectory URLByAppendingPathComponent:@"Twic.sqlite"];
}

+ (void)clearDefaultStore
{
  [[NSFileManager defaultManager] removeItemAtURL:[self defaultStoreUrl] error:nil];
}

#pragma mark - ManagedObjectContext setup

- (NSManagedObjectContext *)createMainManagedObjectContext
{
  NSManagedObjectContext *mainManagedObjectContext;
  
  mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  mainManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
  mainManagedObjectContext.undoManager = [[NSUndoManager alloc] init];
  
  return mainManagedObjectContext;
}

@end
