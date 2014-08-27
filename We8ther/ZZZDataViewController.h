//
//  ZZZDataViewController.h
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZZLocationModel;

@interface ZZZDataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (strong, nonatomic) ZZZLocationModel *locationModel;

@end
