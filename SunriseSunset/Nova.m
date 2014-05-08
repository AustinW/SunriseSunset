//
//  Nova.m
//  SunriseSunset
//
//  Created by Austin White on 5/1/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "Nova.h"

#include <libnova/solar.h>
#include <libnova/julian_day.h>
#include <libnova/rise_set.h>
#include <libnova/transform.h>
#include <libnova/utility.h>
#include <libnova/refraction.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

@interface Nova()
// Private methods
- (NSDictionary *)compileTimesFromRise:(struct ln_zonedate *)rise andSet:(struct ln_zonedate *)set;
@end

@implementation Nova

@synthesize latitude = _latitude, longitude = _longitude;

- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude
{
    if (self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
    }
    
    return self;
}

- (BOOL)hasLocation
{
    return self.latitude != 0 && self.longitude != 0;
}

# pragma mark - Libnova C utilities

static struct ln_lnlat_posn observer;
static struct ln_helio_posn position;
static struct ln_equ_posn equatorial_coordinates;

static double JulianDate;

float convFtoC(float tempF)
{
    return (float) (5.0 * (tempF - 32) / 9.0);
}

float convinHgtomb(float pressureinHg)
{
    return (float) (33.8639 * pressureinHg);
}

float calc_daylight_hours(struct ln_zonedate *r, struct ln_zonedate *s)
{
    struct tm br, bs;
    time_t cr, cs;
    float h = 0;
    
    br.tm_year = bs.tm_year = s->years - 1900;
    br.tm_mon = bs.tm_mon = s->months - 1;
    br.tm_mday = bs.tm_mday = s->days;
    br.tm_hour = r->hours;
    br.tm_min = r->minutes;
    br.tm_sec = round(r->seconds);
    bs.tm_hour = s->hours;
    bs.tm_min = s->minutes;
    bs.tm_sec = round(s->seconds);
    cr = mktime(&br);
    cs = mktime(&bs);
    if (cr != -1 && cs != -1)
        h = (float) (cs - cr) / 3600.0;
    
    return (h);
}

# pragma mark - Nova calculation methods

- (void)calcCommonWithLatitude:(double)latitude andLongitude:(double)longitude
{
    observer.lat = latitude;
    observer.lng = longitude;
    
    JulianDate = ln_get_julian_from_sys();
    
    ln_get_solar_geom_coords(JulianDate, &position);
    ln_get_solar_equ_coords(JulianDate, &equatorial_coordinates);
}

- (NSDictionary *)calculateRst
{
    BOOL consoleLog = NO;

    [self calcCommonWithLatitude:self.latitude andLongitude:self.longitude];

    NSDictionary *allCalculations, *standard, *civil, *nautical, *astronomical;
    
    struct ln_rst_time rst;
    struct ln_zonedate rise, set, transit;
    
    if (consoleLog) printf("LN_SOLAR_STANDART_HORIZON: %g\n", LN_SOLAR_STANDART_HORIZON );
    if (consoleLog) printf("\n");

    if (ln_get_solar_rst_horizon(JulianDate, &observer, LN_SOLAR_STANDART_HORIZON, &rst) == 1) {
        if (consoleLog) printf ("Sun is circumpolar\n");
    } else {
        
        ln_get_local_date(rst.rise, &rise);
        ln_get_local_date(rst.transit, &transit);
        ln_get_local_date(rst.set, &set);

        standard = [self compileTimesFromRise:&rise andSet:&set];
        
        if (consoleLog) printf( "rise: %.2d:%.2d:%.2d\n", rise.hours, rise.minutes, (int) round(rise.seconds) );
        if (consoleLog) printf( "set: %.2d:%.2d:%.2d\n", set.hours, set.minutes, (int) round(set.seconds) );
        if (consoleLog) printf( "daylight hours: %g\n", calc_daylight_hours(&rise, &set) );
    }
    
    if (consoleLog) printf("LN_SOLAR_CIVIL_HORIZON: %g\n", LN_SOLAR_CIVIL_HORIZON );
    if (consoleLog) printf("Civil twilight is defined to begin in the morning, and to end in the evening when the center of the Sun is geometrically 6 degrees below the horizon. This is the limit at which twilight illumination is sufficient, under good weather conditions, for terrestrial objects to be clearly distinguished; at the beginning of morning civil twilight, or end of evening civil twilight, the horizon is clearly defined and the brightest stars are visible under good atmospheric conditions in the absence of moonlight or other illumination. In the morning before the beginning of civil twilight and in the evening after the end of civil twilight, artificial illumination is normally required to carry on ordinary outdoor activities.\n");
    
    if (ln_get_solar_rst_horizon(JulianDate, &observer, LN_SOLAR_CIVIL_HORIZON, &rst) == 1) {
        if (consoleLog) printf ("Sun is circumpolar\n");
    } else {
        
        ln_get_local_date(rst.rise, &rise);
        ln_get_local_date(rst.transit, &transit);
        ln_get_local_date(rst.set, &set);
        
        civil = [self compileTimesFromRise:&rise andSet:&set];
        
        if (consoleLog) printf( "rise: %.2d:%.2d:%.2d\n", rise.hours, rise.minutes, (int) round(rise.seconds) );
        if (consoleLog) printf( "set: %.2d:%.2d:%.2d\n", set.hours, set.minutes, (int) round(set.seconds) );
        if (consoleLog) printf( "daylight hours: %g\n", calc_daylight_hours(&rise, &set) );
    }

    if (consoleLog) printf("LN_SOLAR_NAUTIC_HORIZON: %g\n", LN_SOLAR_NAUTIC_HORIZON );
    if (consoleLog) printf("Nautical twilight is defined to begin in the morning, and to end in the evening, when the center of the sun is geometrically 12 degrees below the horizon. At the beginning or end of nautical twilight, under good atmospheric conditions and in the absence of other illumination, general outlines of ground objects may be distinguishable, but detailed outdoor operations are not possible. During nautical twilight the illumination level is such that the horizon is still visible even on a Moonless night allowing mariners to take reliable star sights for navigational purposes, hence the name.\n");
    
    if (ln_get_solar_rst_horizon(JulianDate, &observer, LN_SOLAR_NAUTIC_HORIZON, &rst) == 1) {
        if (consoleLog) printf ("Sun is circumpolar\n");
    } else {
        
        ln_get_local_date(rst.rise, &rise);
        ln_get_local_date(rst.transit, &transit);
        ln_get_local_date(rst.set, &set);
        
        nautical = [self compileTimesFromRise:&rise andSet:&set];
        
        if (consoleLog) printf( "rise: %.2d:%.2d:%.2d\n", rise.hours, rise.minutes, (int) round(rise.seconds) );
        if (consoleLog) printf( "set: %.2d:%.2d:%.2d\n", set.hours, set.minutes, (int) round(set.seconds) );
        if (consoleLog) printf( "daylight hours: %g\n", calc_daylight_hours(&rise, &set) );
    }
    
    if (consoleLog) printf("LN_SOLAR_ASTRONOMICAL_HORIZON: %g\n", LN_SOLAR_ASTRONOMICAL_HORIZON );
    if (consoleLog) printf("Astronomical twilight is defined to begin in the morning, and to end in the evening when the center of the Sun is geometrically 18 degrees below the horizon. Before the beginning of astronomical twilight in the morning and after the end of astronomical twilight in the evening, scattered light from the Sun is less than that from starlight and other natural sources. For a considerable interval after the beginning of morning twilight and before the end of evening twilight, sky illumination is so faint that it is practically imperceptible.\n");
    
    if (ln_get_solar_rst_horizon(JulianDate, &observer, LN_SOLAR_ASTRONOMICAL_HORIZON, &rst) == 1) {
        if (consoleLog) printf ("Sun is circumpolar\n");
    } else {
        
        ln_get_local_date(rst.rise, &rise);
        ln_get_local_date(rst.transit, &transit);
        ln_get_local_date(rst.set, &set);
        
        astronomical = [self compileTimesFromRise:&rise andSet:&set];
        
        if (consoleLog) printf( "rise: %.2d:%.2d:%.2d\n", rise.hours, rise.minutes, (int) round(rise.seconds) );
        if (consoleLog) printf( "set: %.2d:%.2d:%.2d\n", set.hours, set.minutes, (int) round(set.seconds) );
        if (consoleLog) printf( "daylight hours: %g\n", calc_daylight_hours(&rise, &set) );
    }
    
    allCalculations = @{@"standard":     standard,
                        @"civil":        civil,
                        @"nautical":     nautical,
                        @"astronomical": astronomical};
    
    return allCalculations;
	
}

- (NSDictionary *)compileTimesFromRise:(struct ln_zonedate *)rise andSet:(struct ln_zonedate *)set
{
    return @{@"rise":
                 @{@"hour":   [NSNumber numberWithInt:rise->hours],
                   @"minute": [NSNumber numberWithInt:rise->minutes],
                   @"second": [NSNumber numberWithInt:round(rise->seconds)]},
             
             @"set":
                 @{@"hour":   [NSNumber numberWithInt:set->hours],
                   @"minute": [NSNumber numberWithInt:set->minutes],
                   @"second": [NSNumber numberWithInt:round(set->seconds)]},
             
             @"daylight_hours": [NSNumber numberWithDouble:calc_daylight_hours(rise, set)]};
}

@end
