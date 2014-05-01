//
//  CitiesTableViewController.h
//  SunriseSunset
//
//  Created by Austin White on 4/29/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"

@interface CitiesTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, strong) MainViewController *mainViewControllerReference;

@end
