//
//  ZZZLocationViewController.h
//  We8ther
//
//  Created by _Zach on 6/4/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZZLocationViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) void (^callback)();
- (IBAction)doneTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;

@end
