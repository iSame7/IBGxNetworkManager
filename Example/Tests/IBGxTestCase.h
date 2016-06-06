//
//  IBGxTestCase.h
//  IBGxNetworkManager
//
//  Created by Sameh Mabrouk on 6/5/16.
//  Copyright © 2016 smapps. All rights reserved.
//

#import <XCTest/XCTest.h>

extern NSString * const IBGxTestingBaseURLString;

@interface IBGxTestCase : XCTestCase

@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, assign) NSTimeInterval networkTimeout;

- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler;

@end
