//
//  ZZZModelController.m
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import "ZZZModelController.h"
#import "ZZZLocationModel.h"
#import "ZZZDataViewController.h"
#import <CoreLocation/CoreLocation.h>

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ZZZModelController()
@property (strong, nonatomic) NSArray *pageData;
@end

@implementation ZZZModelController

+ (void)savePlacemarkToStore:(CLPlacemark *)placemark {
    // check if theres already saved data and append
    ZZZLocationModel *model = [[ZZZLocationModel alloc] initWithPlacemark:placemark];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *storedArray = nil;
    storedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"we8ther_locations"]];
    
    if (storedArray) {
        [storedArray addObject:model];
    }
    else {
        storedArray = [[NSMutableArray alloc] initWithObjects:model, nil];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:storedArray];
    [defaults setObject:data forKey:@"we8ther_locations"];
    [defaults synchronize];
}

- (id)init {
    self = [super init];
    if (self) {
        [self reloadLocationData];
    }
    return self;
}

- (void)reloadLocationData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.pageData = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"we8ther_locations"]];
    
    if ([self.pageData count] == 0) {
        self.needLocations = YES;
    }
    else {
        self.needLocations = NO;
    }
}

- (ZZZDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ZZZDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"ZZZDataViewController"];
    dataViewController.locationModel = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(ZZZDataViewController *)viewController {
    return [self.pageData indexOfObject:viewController.locationModel];
}

#pragma mark - Page View Controller Data Source
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.pageData count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(ZZZDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(ZZZDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
