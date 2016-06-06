//
//  IBGxImageDownloadManager.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxImageDownloadManager.h"
#import "IBGxImageResponseRepresenter.h"

@implementation IBGxImageDownloadManager

- (instancetype)init {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    IBGxNetworkManager *networkManager = [[IBGxNetworkManager alloc] initWithSessionConfiguration:defaultConfiguration];
    networkManager.responsBuilder = [IBGxImageResponseRepresenter responseBuilder];

    return [self initWithIBGxNetworkManager:networkManager];
}

- (instancetype)initWithIBGxNetworkManager:(IBGxNetworkManager *)networkManager {

    if (self = [super init]) {
        self.networkManager = networkManager;
    }

    return self;
}

+ (instancetype)sharedInstance {

    static IBGxImageDownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;

}

- (void)downloadImageForURLRequest:(NSURLRequest *)request success:(void (^)(NSHTTPURLResponse * _Nullable, UIImage * _Nonnull))success failure:(void (^)( NSHTTPURLResponse * _Nullable, NSError * _Nonnull))failure {

    NSURLSessionDataTask *dataTask;
    dataTask = [self.networkManager createDataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            if (failure) {
                failure((NSHTTPURLResponse*)response, error);
            }
        } else {
            if (success) {
                success((NSHTTPURLResponse*)response, responseObject);
            }
        }

    }];
    [dataTask resume];
    
}

@end
