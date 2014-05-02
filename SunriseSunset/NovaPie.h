//
//  NovaPie.h
//  SunriseSunset
//
//  Created by Austin White on 5/1/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nova.h"

@interface NovaPie : NSObject

@property (nonatomic, strong) Nova *nova;
@property (nonatomic, strong) NSDictionary *novaInfo;

- (id)initWithInfo:(NSDictionary *)novaInfo;
- (NSArray *)getSlices;

@end
