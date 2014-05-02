//
//  NovaPie.m
//  SunriseSunset
//
//  Created by Austin White on 5/1/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "NovaPie.h"
#import "Nova.h"

@implementation NovaPie

@synthesize nova, novaInfo = _novaInfo;

- (id)initWithInfo:(NSDictionary *)novaInfo
{
    if (self = [super init]) {
        _novaInfo = novaInfo;
    }
    
    return self;
}

- (NSArray *)getSlices
{
    NSMutableArray *slices = [[NSMutableArray alloc] initWithCapacity:4];
    
    static NSUInteger totalSeconds = 60 * 60 * 24;
    
    double daylightPortion = ([[self.novaInfo objectForKey:@"daylightTime"] doubleValue] / totalSeconds) * 100.0;
    double nightTimePortion = ([[self.novaInfo objectForKey:@"nightTime"] doubleValue] / totalSeconds) * 100.0;
    
    [slices addObject:[NSNumber numberWithDouble:daylightPortion]];
    [slices addObject:[NSNumber numberWithDouble:nightTimePortion]];
    
    return slices;
}

- (double)totalSecondsFromDictionary:(NSDictionary *)novaInfoPartial
{
    double total = 0;
    
    total += [[novaInfoPartial objectForKey:@"hour"] doubleValue] * 3600;
    total += [[novaInfoPartial objectForKey:@"minute"] doubleValue] * 60;
    total += [[novaInfoPartial objectForKey:@"second"] doubleValue];
    
    return total;
}

@end
