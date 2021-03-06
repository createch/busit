//
//  BIArrivals.m
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BIArrival.h"

@interface BIArrival () {}
    @property BIBusData *busData;
@end

@implementation BIArrival

@synthesize gtfsId, obaId, routeId, vehicleId, scheduledArrivalTime, scheduledDepartureTime, predictedArrivalTime, predictedDepartureTime, updatedTime, direction, tripHeadsign, serviceId, shapeId, stopSequence, distanceFromStop, numberOfStopsAway, position, lastUpdateTime, scheduleDeviation, distanceAlongTrip, scheduledDistanceAlongTrip, totalDistanceAlongTrip, nextStopTimeOffset, hasObaData, identifier;

@synthesize busData;

- (id)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        hasObaData = NO;
        gtfsId = [NSString stringWithFormat:@"%@", resultDict[@"trip_id"]];
        identifier = gtfsId;
        obaId = [NSString stringWithFormat:@"%@%@", regionPrefix, gtfsId];
        scheduledArrivalTime = [BIBusData dateFromGtfsTimestring:resultDict[@"arrival_time"]];
        scheduledDepartureTime = [BIBusData dateFromGtfsTimestring:resultDict[@"departure_time"]];
        routeId = [resultDict[@"route_id"] stringValue];
        direction = resultDict[@"direction"];
        tripHeadsign = resultDict[@"trip_headsign"];
        serviceId = resultDict[@"service_id"];
        shapeId = resultDict[@"shape_id"];
        stopSequence = resultDict[@"stop_sequence"];
    }
    return self;
}


- (void)updateWithOBAData:(NSDictionary *)obaData {
    hasObaData = YES;
    vehicleId = obaData[@"vehicleId"];
    lastUpdateTime = [BIRest dateFromObaTimestamp:obaData[@"lastUpdateTime"]];
    predictedDepartureTime = [BIRest dateFromObaTimestamp:obaData[@"predictedDepartureTime"]];
    predictedArrivalTime = [BIRest dateFromObaTimestamp:obaData[@"predictedArrivalTime"]];
    numberOfStopsAway = obaData[@"numberOfStopsAway"];
    distanceFromStop = obaData[@"distanceFromStop"];
    if ([obaData[@"tripStatus"] isKindOfClass:[NSDictionary class]]) {
        position = [[CLLocation alloc] initWithLatitude:[obaData[@"tripStatus"][@"position"][@"lat"] doubleValue] longitude:[obaData[@"tripStatus"][@"position"][@"lon"] doubleValue]];
        scheduleDeviation = obaData[@"tripStatus"][@"scheduleDeviation"];
        distanceAlongTrip = obaData[@"tripStatus"][@"distanceAlongTrip"];
        scheduledDistanceAlongTrip = obaData[@"tripStatus"][@"scheduledDistanceAlongTrip"];
        totalDistanceAlongTrip = obaData[@"tripStatus"][@"totalDistanceAlongTrip"];
        nextStopTimeOffset = obaData[@"tripStatus"][@"nextStopTimeOffset"];
    }
    else {
        NSLog(@"The OBA Data doesn't have a tripStatus section.");
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Arrival: %@ %@>", identifier, tripHeadsign];
}

- (NSString *)formattedScheduleDeviation
{
    // http://developer.onebusaway.org/modules/onebusaway-application-modules/1.0.1/apidocs/org/onebusaway/realtime/api/VehicleLocationRecord.html#getScheduleDeviation()
    int deviation = [scheduleDeviation doubleValue] / 60;
    NSString *relative;

    if (deviation < 0)
        relative = @"early";
    else if (deviation > 0)
        relative = @"late";
    else
        return @"On time";

    deviation = abs(deviation);
    NSString *mins = @"mins";
    if (deviation == 1)
        mins = @"min";

    return [NSString stringWithFormat:@"%d %@ %@", deviation, mins, relative];
}

- (NSString *)formattedDistanceFromStop
{
    float meters = [distanceFromStop floatValue];
    float miles = meters * 0.000621371192;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f mi", miles];
    return distanceString;
}

@end
