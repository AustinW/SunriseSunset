//
//  ViewController.h
//  SunriseSunset
//
//  Created by Austin White on 4/28/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end
