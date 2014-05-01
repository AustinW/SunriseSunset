//
//  ViewController.m
//  SunriseSunset
//
//  Created by Austin White on 4/28/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <FMDatabase.h>
#import <libnova/solar.h>
#import <libnova/julian_day.h>
#import <libnova/rise_set.h>
#import <libnova/transform.h>

#import "MainViewController.h"
#import "CitiesTableViewController.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCities;

- (void)getCoordinatesFromAddress:(NSString *)city;

@end

@implementation MainViewController

@synthesize managedObjectContext;
@synthesize selectedCity;
@synthesize geocoder = _geocoder;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Managed Context from MainViewController: %@", self.managedObjectContext);
}

- (CLGeocoder *)geocoder
{
    if ( ! _geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedCity) {
        [self getCoordinatesFromAddress:self.selectedCity];
    }
}

- (void)getCoordinatesFromAddress:(NSString *)city
{
    [self.geocoder geocodeAddressString:city completionHandler:^(NSArray* placemarks, NSError* error)
    {
        NSLog(@"Placemarks: %ld", placemarks.count);
        
        for (CLPlacemark *placemark in placemarks)
        {
            // Process the placemark.
            NSString *latitude = [NSString stringWithFormat:@"%.8f", placemark.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%.8f", placemark.location.coordinate.longitude];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectCitySegue"])
    {
        // Get reference to the destination view controller
        CitiesTableViewController *destinationViewController = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        destinationViewController.managedObjectContext = self.managedObjectContext;
        destinationViewController.mainViewControllerReference = self;
    }
}

@end
