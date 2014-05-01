//
//  RootNavigationController.m
//  SunriseSunset
//
//  Created by Austin White on 4/29/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "RootNavigationController.h"
#import "MainViewController.h"

@implementation RootNavigationController

@synthesize managedObjectContext;

- (void)viewDidLoad
{
    MainViewController *rootViewController = [self rootViewController];
    rootViewController.managedObjectContext = self.managedObjectContext;
}

- (MainViewController *)rootViewController
{
    return [[self viewControllers] firstObject];
}

@end
