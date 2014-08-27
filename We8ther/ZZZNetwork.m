//
//  ZZZNetwork.m
//  DrippyPixel
//
//  Created by _Zach on 5/28/14.
//  Copyright (c) 2014 Compoucher. All rights reserved.
//

#import "ZZZNetwork.h"
#import "ZZZLocationModel.h"

@interface ZZZNetwork ()

@property (nonatomic, strong) NSString *serverHostname;
@property (nonatomic, strong) NSURLSessionConfiguration *defaultConfiguration;
@property (nonatomic, strong) NSURLSessionTask *activeTask;

@end

@implementation ZZZNetwork

+ (id)sharedInstance {
    static ZZZNetwork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.serverHostname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"server"];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders:@{@"Accept" : @"application/json"} ];
        
        // TODO set basic auth
        [sessionConfig setHTTPAdditionalHeaders:@{@"Authorization": @"blahhh"}];
        instance.defaultConfiguration = sessionConfig;
        
        instance.activeTask = nil;
    });
    return instance;
}

// TODO change the network call around
- (NSURL *)URLForLocation:(ZZZLocationModel *)location {
    NSString *theString = [NSString stringWithFormat:@"%@/weather?cityState=%@&lat=%f&lng=%f",self.serverHostname, location.cityState, location.coordinate.latitude, location.coordinate.longitude];
    theString = [theString stringByReplacingOccurrencesOfString:@" " withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"," withString:@""];
    return [NSURL URLWithString:[theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)weatherAtLocation:(ZZZLocationModel *)location completion:(void (^)(NSDictionary *))callback {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.defaultConfiguration];
    NSURL *url = [self URLForLocation:location];
    self.activeTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode != 200) {
            return;
        }
        
        NSError *jsonError;
        NSDictionary *weatherJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&jsonError];
        if (jsonError) {
            [NSException raise:@"failed to decode JSON" format:@"JSON decode error"];
            return;
        }
        
       dispatch_async(dispatch_get_main_queue(), ^{
           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
           if (callback) {
               callback(weatherJSON);
           }
       });
    }];
    
    [self.activeTask resume];
}

- (void)cancelCurrentSessionTask {
    [self.activeTask cancel];
}

@end
