//
//  ZZZLocationModel.h
//  We8ther
//
//  Created by _Zach on 6/5/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZZZLocationModel : NSObject <NSCoding>

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark;

@property (strong, nonatomic) NSString *cityState;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
