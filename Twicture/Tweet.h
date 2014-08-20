//
//  Tweet.h
//  Twic
//
//  Created by Adam Salvitti-Gucwa on 8/20/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * sent;
@property (nonatomic, retain) NSString * account;

@end
