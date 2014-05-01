//
//  RootNavigationController.h
//  SunriseSunset
//
//  Created by Austin White on 4/29/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface RootNavigationController : UINavigationController

@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;

@end
