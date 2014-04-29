//
//  Database.m
//  MassTransit
//
//  Created by Austin White on 3/24/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "Database.h"

@implementation Database

static Database *_databaseObj;

@synthesize databaseConnection = _databaseConnection;

#pragma mark - Initializer

- (id)init
{
    self = [super init];
    
    if (self) {
        _databaseConnection = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"us_cities_with_timezones" ofType:@"sl3"]];
        
        if ( ! [_databaseConnection open]) {
            NSLog(@"Unable to open database: %@", [_databaseConnection lastErrorMessage]);
        } else {
            NSLog(@"Database open");
        }
        
    }
    
    return self;
}

# pragma mark - Deallocator

- (void) dealloc
{
    [_databaseConnection close];
}

@end
