//
//  IBGxAPIClient.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/4/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxAPIClient.h"

static NSString * const IBxAPIBaseURLString = @"https://api.app.net/";

@implementation IBGxAPIClient

+ (instancetype)sharedClient {
    static IBGxAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[IBGxAPIClient alloc] initWithBaseURL:[NSURL URLWithString:IBxAPIBaseURLString]];
    });

    return _sharedClient;
}

@end
