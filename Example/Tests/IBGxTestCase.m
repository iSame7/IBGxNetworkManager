//
//  IBGxTestCase.m
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import "IBGxTestCase.h"

NSString * const IBGxTestingBaseURLString = @"https://api.app.net/";

@implementation IBGxTestCase

- (void)setUp {
    [super setUp];
    self.networkTimeout = 20.0;
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark -

- (NSURL *)baseURL {
    return [NSURL URLWithString:IBGxTestingBaseURLString];
}

- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler {
    [self waitForExpectationsWithTimeout:self.networkTimeout handler:handler];
}


@end
