//
//  ZZZModelController.h
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZZDataViewController;

@interface ZZZModelController : NSObject <UIPageViewControllerDataSource>

- (ZZZDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(ZZZDataViewController *)viewController;

@end
