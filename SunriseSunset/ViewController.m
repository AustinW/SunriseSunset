//
//  ViewController.m
//  SunriseSunset
//
//  Created by Austin White on 4/28/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//
#import <FMDatabase.h>
#import <libnova/solar.h>
#import <libnova/julian_day.h>
#import <libnova/rise_set.h>
#import <libnova/transform.h>

#import "ViewController.h"
#import "Cities.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCities;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    Cities *cities = [[Cities alloc] init];
    
    NSArray *allCities = [cities all];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
