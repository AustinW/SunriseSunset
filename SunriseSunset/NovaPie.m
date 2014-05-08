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
    
    static NSUInteger totalSeconds = 60 * 60 * 24; // # of seconds in a day
    
    //86400-78503+15716+50349+2354+2133+1731+1732+2133+2355
    
    // First slice is from astronomical set to astronomical rise
    NSDictionary *astronomicalRise = [[self.novaInfo objectForKey:@"astronomical"] objectForKey:@"rise"];
    NSDictionary *astronomicalSet = [[self.novaInfo objectForKey:@"astronomical"] objectForKey:@"set"];
    
    double astronomicalSlice = totalSeconds - [NovaPie secondsFromDictionary:astronomicalSet] + [NovaPie secondsFromDictionary:astronomicalRise];
    
    [slices addObject:[NSNumber numberWithDouble:astronomicalSlice]];
    
    // Second slice is from astronomical rise to nautical rise
    [slices addObject:[self sliceFromCategory1:@"astronomical" partial1:@"rise" andCategory2:@"nautical" partial2:@"rise"]];
    
    // Third slice is from nautical rise to civil rise
    [slices addObject:[self sliceFromCategory1:@"nautical" partial1:@"rise" andCategory2:@"civil" partial2:@"rise"]];
    
    // Fourth slice is from civil rise to standard rise
    [slices addObject:[self sliceFromCategory1:@"civil" partial1:@"rise" andCategory2:@"standard" partial2:@"rise"]];
    
    // Fifth slice is from standard rise to standard set
    [slices addObject:[self sliceFromCategory1:@"standard" partial1:@"rise" andCategory2:@"standard" partial2:@"set"]];
    
    // Sixth slice is from standard set to civil set
    [slices addObject:[self sliceFromCategory1:@"standard" partial1:@"set" andCategory2:@"civil" partial2:@"set"]];

    // Seventh slice is from civil set to nautical set
    [slices addObject:[self sliceFromCategory1:@"civil" partial1:@"set" andCategory2:@"nautical" partial2:@"set"]];
    
    // Eighth slice is from nautical set to astronomical set
    [slices addObject:[self sliceFromCategory1:@"nautical" partial1:@"set" andCategory2:@"astronomical" partial2:@"set"]];
    
    NSLog(@"Slices: %@", slices);
    
    
    return slices;
}

- (NSNumber *)sliceFromCategory1:(NSString *)category1 partial1:(NSString *)partial1 andCategory2:(NSString *)category2 partial2:(NSString *)partial2
{
    NSDictionary *chunk1 = [[self.novaInfo objectForKey:category1] objectForKey:partial1];
    NSDictionary *chunk2 = [[self.novaInfo objectForKey:category2] objectForKey:partial2];
    
    double timeSlice = [NovaPie secondsFromDictionary:chunk2] - [NovaPie secondsFromDictionary:chunk1];
    
    return [NSNumber numberWithDouble:timeSlice];
}

+ (double)secondsFromDictionary:(NSDictionary *)info
{
    double total = 0;
    
    total += [[info objectForKey:@"hour"] doubleValue] * 3600.0;
    total += [[info objectForKey:@"minute"] doubleValue] * 60.0;
    total += [[info objectForKey:@"second"] doubleValue];
    
    return total;
}

@end
