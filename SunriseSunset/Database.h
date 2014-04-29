//
//  Database.h
//  MassTransit
//
//  Created by Austin White on 3/24/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface Database : NSObject

@property (nonatomic, strong) FMDatabase *databaseConnection;

@end
