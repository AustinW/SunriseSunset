//
//  ViewController.m
//  SunriseSunset
//
//  Created by Austin White on 4/28/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <libnova/solar.h>
#import <libnova/julian_day.h>
#import <libnova/rise_set.h>
#import <libnova/transform.h>

#import "MainViewController.h"
#import "CitiesTableViewController.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCities;

- (void)getCoordinatesFromAddress:(NSString *)city;
- (Nova *)novaWithLatitude:(double)latitude andLongitude:(double)longitude;

@end

@implementation MainViewController

@synthesize managedObjectContext;
@synthesize selectedCity;
@synthesize geocoder = _geocoder;
@synthesize locationManager = _locationManager;
@synthesize lblLocation = _lblLocation;
@synthesize nova = _nova;
@synthesize novaPie = _novaPie;
@synthesize sunriseSunset = _sunriseSunset;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // 3000 m
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_4];
    [self.pieChart setAnimationSpeed:1];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"Helvetica Neue" size:24]];
    [self.pieChart setLabelColor:[UIColor blackColor]];
//    [self.pieChart setLabelRadius:60];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
    CGFloat xCenter = self.view.bounds.origin.x + self.pieChart.bounds.origin.x + self.pieChart.bounds.size.width / 2;
    CGFloat yCenter = self.view.bounds.origin.y + self.pieChart.bounds.origin.y + self.pieChart.bounds.size.height / 2;

    [self.pieChart setPieCenter:CGPointMake(xCenter, yCenter)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.nova.hasLocation) {
        [self.pieChart reloadData];
    }
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [[self.novaPie getSlices] count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[[self.novaPie getSlices] objectAtIndex:index] doubleValue];
}

- (CLLocationManager *)locationManager
{
    if ( ! _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if ( ! _geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (Nova *)nova
{
    if ( ! _nova) {
        _nova = [[Nova alloc] init];
    }
    
    return _nova;
}

- (Nova *)novaWithLatitude:(double)latitude andLongitude:(double)longitude
{
    if ( ! _nova) {
        _nova = [[Nova alloc] initWithLatitude:latitude andLongitude:longitude];
    }
    
    return _nova;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedCity) {
        [self.lblLatitude setHidden:NO];
        [self.lblLongitude setHidden:NO];
        [self.lblLatitudeValue setHidden:NO];
        [self.lblLongitudeValue setHidden:NO];
        
        [self getCoordinatesFromAddress:self.selectedCity];
        [self.lblLocation setText:self.selectedCity];
    } else {
        [self.lblLatitude setHidden:YES];
        [self.lblLongitude setHidden:YES];
        [self.lblLatitudeValue setHidden:YES];
        [self.lblLongitudeValue setHidden:YES];
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

#pragma mark - Core Location

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        
        self.lblLocation.text = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
        
        self.nova.latitude = newLocation.coordinate.latitude;
        self.nova.longitude = newLocation.coordinate.longitude;
        
        self.novaPie = [[NovaPie alloc] initWithInfo:[self.nova calculate]];
        
        [self.pieChart reloadData];
    }];
    
    NSLog(@"Update location with: %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed %ld",(long)[error code]);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Location authorization changed: %u", status);
}

- (IBAction)getCurrentLocation:(id)sender {
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // 3000 m
    
    [self.locationManager startUpdatingLocation];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        NSLog(@"Location Services Are Enabled");
        
        switch([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"User has not yet made a choice with regards to this application");
                break;
            case kCLAuthorizationStatusRestricted:
                NSLog(@"This application is not authorized to use location services.  Due\
                      to active restrictions on location services, the user cannot change\
                      this status, and may not have personally denied authorization");
                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"User has explicitly denied authorization for this application, or\
                      location services are disabled in Settings");
                break;
            case kCLAuthorizationStatusAuthorized:
                NSLog(@"User has authorized this application to use location services");
                
                break;
        }
    } else {
        NSLog(@"Location Services Disabled");
    }
    
}
@end
