//
//  BusStopAnnotation.m
//  BusStop
//
//  Created by Adam Lowther on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusStopAnnotation.h"

@implementation BusStopAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)setCoordinate{
    self = [super init];
    if(self) {
        coordinate = setCoordinate;
    }
    return self;
}

-(NSString *)title {
    return title;
}

-(NSString *)subtitle {
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.alertLatitude doubleValue];
    coordinate.longitude = [self.alertLongitude doubleValue];
    return coordinate;
}

@end