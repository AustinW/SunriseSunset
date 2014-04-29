//
//  Cities.m
//  
//
//  Created by Austin White on 4/29/14.
//
//

#import "Cities.h"

@implementation Cities

@synthesize database = _database;

- (id)init
{
    self = [super init];
    
    if (self) {
        _database = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"us_cities_with_timezones" ofType:@"sl3"]];
        
        if ( ! [_database open]) {
            NSLog(@"Unable to open database: %@", [_database lastErrorMessage]);
        }
    }
    
    return self;
}

- (unsigned long)count
{
    FMResultSet *result = [self.database executeQuery:@"SELECT COUNT(*) FROM cities"];
    
    if ([result next]) {
        return [result intForColumnIndex:0];
    }
    
    return 0;
}

- (NSArray *)all
{
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    FMResultSet *result = [self.database executeQuery:@"SELECT name, state, latitude, longitude, time_zone FROM cities ORDER BY state ASC, name ASC"];
    
    while ([result next]) {
        [cities addObject:[result resultDictionary]];
    }
    
    NSLog(@"Cities count: %lu", (unsigned long)[cities count]);
    
    return cities;
}

@end
