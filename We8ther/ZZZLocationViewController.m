//
//  ZZZLocationViewController.m
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import "ZZZLocationViewController.h"
#import "ZZZModelController.h"
#import <CoreLocation/CoreLocation.h>

@interface ZZZLocationViewController ()

@end

@implementation ZZZLocationViewController

// TODO Core Location Stuff. Try out CL geocodeAddressString:completionHandler:
// type in City name and submit. This will return geocoded coords. Submit these to server.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tappy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tappy];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (![CLLocationManager locationServicesEnabled]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location" message:@"Please enable location services" delegate:self cancelButtonTitle:@"Game Over" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // no op
}

- (IBAction)doneTouch:(id)sender {
    
    __block typeof(self) blockSelf = self;
    NSString *address = [NSString stringWithFormat:@"%@, %@", self.cityField.text, self.stateField.text];
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location"
                                                            message:@"Sorry, we dont know that kingdom"
                                                           delegate:self
                                                  cancelButtonTitle:@"Game Over"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        [ZZZModelController savePlacemarkToStore:[placemarks firstObject]];
        blockSelf.callback();
    }];
}

- (void)viewTap:(id)target {
    [self.view endEditing:YES];
}

@end
