//
//  ViewController.h
//  SunriseSunset
//
//  Created by Austin White on 4/28/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <XYPieChart/XYPieChart.h>
#import "Nova.h"
#import "NovaPie.h"

@interface MainViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@property (nonatomic, strong) Nova *nova;
@property (nonatomic, strong) NovaPie *novaPie;
@property (nonatomic, strong) NSDictionary *sunriseSunset;
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;
@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitudeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLongitudeValue;

- (IBAction)getCurrentLocation:(id)sender;


@end
