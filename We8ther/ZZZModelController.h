//
//  ZZZModelController.h
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ZZZForecastViewController;

@interface ZZZModelController : NSObject <UIPageViewControllerDataSource>

@property (assign, nonatomic) BOOL needLocations;
- (void)reloadLocationData;
- (ZZZForecastViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(ZZZForecastViewController *)viewController;

+ (void)savePlacemarkToStore:(CLPlacemark *)place;

@end
