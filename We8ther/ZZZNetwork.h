//
//  ZZZNetwork.h
//  DrippyPixel
//
//  Created by _Zach on 5/28/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZZLocationModel;
@interface ZZZNetwork : NSObject

+ (instancetype) sharedInstance;

- (void)weatherAtLocation:(ZZZLocationModel *)location completion:(void(^)(NSDictionary * weatherJSON))callback;
- (void)cancelCurrentSessionTask;
@end
