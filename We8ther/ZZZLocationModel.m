//
//  ZZZLocationModel.m
//  We8ther
//
//  Created by _Zach on 6/5/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import "ZZZLocationModel.h"

@implementation ZZZLocationModel

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark {
    self = [super init];
    if (self){
        self.coordinate = placemark.location.coordinate;
        self.cityState = [placemark.addressDictionary[@"FormattedAddressLines"] componentsJoinedByString:@","];
        
        // TODO look up the timezone associated with the location
        // TODO other little things to determine icon and such for the location...
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:self.coordinate.longitude forKey:@"lng"];
    [encoder encodeDouble:self.coordinate.latitude forKey:@"lat"];
    [encoder encodeObject:self.cityState forKey:@"cityState"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        double lng = [decoder decodeDoubleForKey:@"lng"];
        double lat = [decoder decodeDoubleForKey:@"lat"];
        
        self.coordinate = CLLocationCoordinate2DMake(lat, lng);
        self.cityState = [decoder decodeObjectForKey:@"cityState"];
    }
    return self;
}

@end
