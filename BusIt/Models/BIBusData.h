//
//  BIBusData.h
//  BusIt
//
//  Created by Lolcat on 8/30/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BIRest.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180


@interface BIBusData : NSObject

// Class Variables
/** Some cities, like Tampa have a custom prefix before all identifiers. Very unusual. */
extern NSString *regionName;
extern NSString *regionPrefix;

// Instance Variables
@property FMDatabase *database;

// Data Access
- (NSArray *)stopsNearLocation:(CLLocation *)location andLimit:(int)limit;
- (NSArray *)routes;

// Helpers
- (NSString *)stringWithoutRegionPrefix:(NSString *)stringWithPrefix;
/** Converts HH:mm:ss to NSDate. */
+ (NSDate *)dateFromGtfsTimestring:(NSString *)timestring;

@end
