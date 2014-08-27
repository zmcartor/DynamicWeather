//
//  ZZZDataViewController.m
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import "ZZZDataViewController.h"
#import "ZZZLocationModel.h"
#import "ZZZLocationViewController.h"
#import "ZZZNetwork.h"

@interface ZZZDataViewController ()

@property (strong, nonatomic) ZZZNetwork *networkClient;
@property (strong, nonatomic) NSDictionary *weather;

@end

@implementation ZZZDataViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.networkClient = [ZZZNetwork sharedInstance];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.cityStateLabel.text = self.locationModel.cityState;
    
    // check the last time weather was updated
    /*
    if (self.weather[@"last_checked"] < some_time_interval) {
    }
     */
    
    __block typeof(self) blockSelf = self;
    [self.networkClient weatherAtLocation:self.locationModel completion:^(NSDictionary *weatherJSON) {
        [blockSelf drawUIWithJSON:weatherJSON];
    }];
}

- (void)drawUIWithJSON:(NSDictionary *)dict {
    // stick in all the cool things into the UI yay!
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
