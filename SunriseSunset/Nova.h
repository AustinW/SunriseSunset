//
//  Nova.h
//  SunriseSunset
//
//  Created by Austin White on 5/1/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <stdio.h>
#include <libnova/solar.h>
#include <libnova/julian_day.h>
#include <libnova/rise_set.h>
#include <libnova/transform.h>

@interface Nova : NSObject

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double date;

- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude;
- (NSDictionary *)calculate;
- (BOOL)hasLocation;
@end
