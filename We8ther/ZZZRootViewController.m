//
//  ZZZRootViewController.m
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import "ZZZRootViewController.h"
#import "ZZZModelController.h"
#import "ZZZDataViewController.h"
#import "ZZZLocationViewController.h"

@interface ZZZRootViewController ()
@property (readonly, strong, nonatomic) ZZZModelController *modelController;
@end

@implementation ZZZRootViewController

@synthesize modelController = _modelController;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.modelController.needLocations) {
        ZZZLocationViewController *location = [self.storyboard instantiateViewControllerWithIdentifier:@"locationSelection"];
        ZZZLocationViewController __block *blah = location;
        
        location.callback = ^{
            [self.modelController reloadLocationData];
            [self loadPageViewController];
            [blah dismissViewControllerAnimated:YES completion:nil];
        };
        
        [self presentViewController:location animated:YES completion:nil];
        
    } else {
        [self loadPageViewController];
    }
}

- (void)loadPageViewController {
    if (self.pageViewController) {
        [self.modelController reloadLocationData];
        
        ZZZDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
        NSArray *viewControllers = @[startingViewController];
        
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        return;
    }
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
   
    ZZZDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    // Experimental stuff to grab the page view control :o
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    
    thisControl.backgroundColor = [UIColor blueColor];
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setTitle:@"+" forState:UIControlStateNormal];
    
    moreButton.frame = CGRectMake(0, 0, 50, 50);
    moreButton.backgroundColor = [UIColor redColor];
    [moreButton addTarget:self action:@selector(moreButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [thisControl addSubview:moreButton];
    NSLog(@"The control! %@", thisControl);
}

- (IBAction)moreButtonTap:(id)sender {
    ZZZLocationViewController *location = [self.storyboard instantiateViewControllerWithIdentifier:@"locationSelection"];
    ZZZLocationViewController __block *blah = location;
    location.callback = ^{
        [blah dismissViewControllerAnimated:YES completion:nil];
        // viewDidAppear will call 'loadPageViewController again'
    };
    
    [self presentViewController:location animated:YES completion:nil];
}

- (ZZZModelController *)modelController {
    if (!_modelController) {
        _modelController = [[ZZZModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    ZZZDataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}

@end
