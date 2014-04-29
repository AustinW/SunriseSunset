//
//  Cities.h
//  
//
//  Created by Austin White on 4/29/14.
//
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface Cities : NSObject

@property (strong, nonatomic) FMDatabase *database;

- (unsigned long)count;
- (NSArray *)all;

@end
